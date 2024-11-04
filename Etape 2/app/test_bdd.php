<?php
$servername = "data"; 
$port = 3307;
$username = "user";
$password = "user_password";
$dbname = "test_db";

// Connexion à la base de données
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Requête d'insertion
$sql = "INSERT INTO test_table (message) VALUES ('Hello, World!')";
$conn->query($sql);

// Requête de lecture
$result = $conn->query("SELECT * FROM test_table");
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. " - Message: " . $row["message"]. "<br>";
    }
} else {
    echo "0 results";
}

$conn->close();
?>
