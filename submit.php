<?php
// Connect to the database
include 'db.php';

// Get data from form safely
$fullname =$_POST['fullname'];
$email =$_POST['email'];
$subject =$_POST['subject'];
$message =$_POST['message'];

// Prepare SQL query
$sql = "INSERT INTO user_info (fullname, email, subject, message) 
        VALUES ('fullname', 'email', 'subject', 'message')";

// Execute query
if ($conn->query($sql) === TRUE) {
    echo "Message sent successfully!";
}
else {
    echo "Error: " .$conn->error;
    $conn->close();
}


?>


