terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Réseau Docker
resource "docker_network" "my_network2" {
  name = "my_network2"
}

# Image NGINX
resource "docker_image" "nginx_image" {
  name = "nginx:1.27"
}

# Image PHP-FPM
resource "docker_image" "php_fpm_image" {
  name = "php:8.3-fpm"
}

# Image MySQL
resource "docker_image" "mysql_image" {
  name = "mysql:8.0"
}

# Conteneur HTTP
resource "docker_container" "http_container" {
  name  = "http"
  image = docker_image.nginx_image.name
  networks_advanced {
    name = docker_network.my_network2.name
  }
  ports {
    internal = 80
    external = 8080
  }
  
  depends_on = [docker_container.script_container]

  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 2/app/nginx.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 2/app"
    container_path = "/app"
  }
}
# Conteneur SCRIPT
resource "docker_container" "script_container" {
  name  = "script"
  image = docker_image.php_fpm_image.name
  networks_advanced {
    name = docker_network.my_network2.name
  }
  
  command = [
    "sh",
    "-c",
    "docker-php-ext-install mysqli && php-fpm"
  ]

  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 2/app"
    container_path = "/app"
  }
}

# Conteneur DATA (MySQL)
resource "docker_container" "data_container" {
  name  = "data"
  image = docker_image.mysql_image.name
  env = [
    "MYSQL_ROOT_PASSWORD=your_root_password",
    "MYSQL_DATABASE=test_db",
    "MYSQL_USER=user",
    "MYSQL_PASSWORD=user_password"
  ]
  networks_advanced {
    name = docker_network.my_network2.name
  }
  ports {
    internal = 3306
    external = 3307
  }
  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 2/data"
    container_path = "/var/lib/mysql"
  }
  # Monte le script SQL d'initialisation
  volumes {
    host_path      = "D:/M2 cours/Semestre 1/Devops MLops/IaC/Etape 2/init.sql"
    container_path = "/docker-entrypoint-initdb.d/init.sql"
  }
}

