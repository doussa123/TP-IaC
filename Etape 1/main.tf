terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Création du réseau Docker
resource "docker_network" "my_network" {
  name = "my_network"
}

# Téléchargement de l'image NGINX
resource "docker_image" "nginx_image" {
  name         = "nginx:1.27"
}

# Téléchargement de l'image PHP-FPM
resource "docker_image" "php_fpm_image" {
  name         = "php:8.3-fpm"
}

# Conteneur HTTP (NGINX)
resource "docker_container" "http_container" {
  name  = "http"
  image = docker_image.nginx_image.name
  networks_advanced {
    name = docker_network.my_network.name
  }
  ports {
    internal = 80
    external = 8080
  }
  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 1/app/nginx.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 1/app"
    container_path = "/app"
  }
}

# Conteneur SCRIPT (PHP-FPM)
resource "docker_container" "script_container" {
  name  = "script"
  image = docker_image.php_fpm_image.name
  networks_advanced {
    name = docker_network.my_network.name
  }
  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 1/app"
    container_path = "/app"
  }
}
