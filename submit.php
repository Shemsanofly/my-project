<?php
// Connect to the database
include 'db.php';

// Get data from the form
fullname =_POST['fullname'];
email =_POST['email'];
subject =_POST['subject'];
message =_POST['message'];

// Insert into database
sql = "INSERT INTO contacts (fullname, email, subject, message) 
        VALUES ('fullname', 'email', 'subject', 'message')";

if (conn->query(sql)) 
    echo "Message sent successfully!";
 else 
    echo "Error: " .conn->error;
}

$conn->close();
?>

