<?php
// submit_contact.php
// Handles contact form submissions and saves to database

// Database connection settings
$host = 'localhost';
$db = 'myprojectdb'; // Change to your DB name
$user = 'root';    // Change to your DB user
$pass = '';// Change to your DB password

// Create connection
$conn = new mysqli($host, $user, $pass, $db);

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

// Get form data
$name = isset($_POST['name']) ? $conn->real_escape_string($_POST['name']) : '';
$email = isset($_POST['email']) ? $conn->real_escape_string($_POST['email']) : '';
$message = isset($_POST['message']) ? $conn->real_escape_string($_POST['message']) : '';

// Simple validation
if ($name && $email && $message) {
    $sql = "INSERT INTO contact_messages (name, email, message) VALUES ('$name', '$email', '$message')";
    if ($conn->query($sql) === TRUE) {
        echo 'Thank you for contacting us!';
    } else {
        echo 'Error: ' . $conn->error;
    }
} else {
    echo 'Please fill in all fields.';
}

$conn->close();
?>
