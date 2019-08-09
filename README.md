# TL;DR
```
./script.sh - on Kubernetes master
```

## This is a simple LAMP stack for k8s.


# Database
Deployed via custom image, using original mysql:5.7 docker image, the only change is that "datadir" points to "/sql", where Persistent Storage was mounted.

## Dockerfile content for database image:

```
FROM mysql:5.7
CMD ["--datadir=/sql"]
```

The mysql password are injected via **secret.yaml** file.

you can generate own password with following script:
```
kubectl create secret generic mysql-password --from-literal=MYSQL_ROOT_PASSWORD='YOUR_PASSWORD_HERE' --dry-run -o yaml > secret.yaml
```

## Database Persistence
The database storage persistence is provided via pv.yaml and pvc.yaml, the hostPath for volume is **/tmp/data**, created by script.sh on Kubernetes master. The storage size is **3GB.**

## Database Pods, Resources and Autoscaling

By default, **mysql-deployment.yaml** will deploy 1 replica with:
request memory: 128Mi; cpu: 250m and
limits memory: 256Mi; cpu: 500m

**mysql-autoscaler.yaml** will scale up to 3 replicas if cpu utilization is above 80 percent.

# Apache-php
apache-php-deployment.yaml use custom image that contain index.php file for database connection check and mysqli installation, you can find the Dockerfile from which the image was build and index.php content below.

## Apache-php Pods, Resources and Autoscaling

By default, **apache-php-deployment.yaml** will deploy 2 replicas with:
request memory: 64Mi; cpu: 250m and
limits memory: 128Mi; cpu: 500m

**mysql-autoscaler.yaml** will scale up to 4 replicas if cpu utilization is above 80 percent.

## Run on local k8s cluster
apache-php-service.yaml expose apache-php deployment publicly via LoadBalancer, make sure you use k8s environment that support this.
If you want to test this on local k8s cluster, such as minikube, you can change expose type to from LoadBalancer to NodePort in file apache-php-service.yaml

## Application Monitoring
There is livenessProbe for both deployments. The livenessProbe check if tcp socket is open on port 80 for apache-php and on port 3306 for mysql every 5 seconds.

## Disadvantages:
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

## Delete deployment
```
./destroyall.sh
```

