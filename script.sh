#!/bin/bash

kubectl apply -f secret.yaml
sleep 3
kubectl apply -f mysql-deployment.yaml
sleep 5
kubectl apply -f mysql-service.yaml
sleep 3
kubectl apply -f apache-php-deployment.yaml
sleep 5
kubectl apply -f apache-php-service.yaml
