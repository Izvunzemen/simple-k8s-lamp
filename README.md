# TL:DR
```
./script.sh
```

## This is a simple LAMP stack for k8s.


Database are deployed via standart mysql docker image, the mysql password are injected via secret.yaml file.

you can generate own password with following script:
```
kubectl create secret generic mysql-password --from-literal=MYSQL_ROOT_PASSWORD='YOUR_PASSWORD_HERE' --dry-run -o yaml > secret.yaml
```

The stack use custom image for apache-php deployment with index.php file for database connection check and installed mysqli, you can find the Dockerfile and index.php content below.

apache-php-service.yaml expose apache-php deployment publically via LoadBalancer, make sure you use k8s enviroment that support this.


##Disadvantages:
Database do not use persistent storage.
Database password are hardcoded into index.php file.



## The apache-php image is builded from Dockerfile with following content:

```
FROM php:apache
RUN apt update && apt upgrade -y
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
copy index.php /var/www/html/index.php
```

## index.php content for Dockerfile:

```
<?php
$link = mysqli_connect("DB_NAME", "DB_USER", "DB_PASSWORD");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}

echo "Success: A proper connection to MySQL was made!" . PHP_EOL;
echo "Host information: " . mysqli_get_host_info($link) . PHP_EOL;

mysqli_close($link);
?>
```
