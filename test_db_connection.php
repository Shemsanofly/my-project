<?php
// test_db_connection.php
// Simple script to test database connection and table structure

header('Content-Type: text/html; charset=utf-8');

// Database configuration
$config = [
    'host' => 'localhost',
    'database' => 'myprojectdb',
    'username' => 'root',
    'password' => '', // Change this to your MySQL password
    'charset' => 'utf8mb4'
];

echo "<h2>Database Connection Test</h2>";
echo "<hr>";

try {
    // Test connection
    $dsn = "mysql:host={$config['host']};dbname={$config['database']};charset={$config['charset']}";
    $pdo = new PDO($dsn, $config['username'], $config['password'], [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false
    ]);
    
    echo "<p style='color: green;'>✅ Database connection successful!</p>";
    
    // Check if table exists
    $tableCheck = $pdo->query("SHOW TABLES LIKE 'contact_messages'");
    if ($tableCheck->rowCount() > 0) {
        echo "<p style='color: green;'>✅ Table 'contact_messages' exists!</p>";
        
        // Show table structure
        $structure = $pdo->query("DESCRIBE contact_messages");
        echo "<h3>Table Structure:</h3>";
        echo "<table border='1' cellpadding='5' cellspacing='0'>";
        echo "<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>";
        while ($row = $structure->fetch()) {
            echo "<tr>";
            echo "<td>{$row['Field']}</td>";
            echo "<td>{$row['Type']}</td>";
            echo "<td>{$row['Null']}</td>";
            echo "<td>{$row['Key']}</td>";
            echo "<td>{$row['Default']}</td>";
            echo "<td>{$row['Extra']}</td>";
            echo "</tr>";
        }
        echo "</table>";
        
        // Count existing records
        $count = $pdo->query("SELECT COUNT(*) as total FROM contact_messages")->fetch();
        echo "<p>📧 Total messages in database: <strong>{$count['total']}</strong></p>";
        
        // Show recent messages (if any)
        if ($count['total'] > 0) {
            $recent = $pdo->query("SELECT fullname, email, subject, created_at FROM contact_messages ORDER BY created_at DESC LIMIT 5");
            echo "<h3>Recent Messages:</h3>";
            echo "<table border='1' cellpadding='5' cellspacing='0'>";
            echo "<tr><th>Name</th><th>Email</th><th>Subject</th><th>Date</th></tr>";
            while ($row = $recent->fetch()) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars($row['fullname']) . "</td>";
                echo "<td>" . htmlspecialchars($row['email']) . "</td>";
                echo "<td>" . htmlspecialchars($row['subject']) . "</td>";
                echo "<td>{$row['created_at']}</td>";
                echo "</tr>";
            }
            echo "</table>";
        }
        
    } else {
        echo "<p style='color: orange;'>⚠️ Table 'contact_messages' does not exist!</p>";
        echo "<p>Please run the database_setup.sql script first.</p>";
    }
    
} catch (PDOException $e) {
    echo "<p style='color: red;'>❌ Database connection failed!</p>";
    echo "<p style='color: red;'>Error: " . htmlspecialchars($e->getMessage()) . "</p>";
    echo "<h3>Troubleshooting:</h3>";
    echo "<ul>";
    echo "<li>Make sure XAMPP MySQL service is running</li>";
    echo "<li>Check if database 'myprojectdb' exists</li>";
    echo "<li>Verify username and password in the configuration</li>";
    echo "<li>Run the database_setup.sql script in phpMyAdmin</li>";
    echo "</ul>";
}

echo "<hr>";
echo "<p><a href='contact.html'>← Back to Contact Form</a></p>";
?>

<style>
body { font-family: Arial, sans-serif; margin: 20px; }
table { border-collapse: collapse; margin: 10px 0; }
th { background-color: #f0f0f0; }
</style>