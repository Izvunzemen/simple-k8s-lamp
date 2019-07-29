#!/bin/bash
echo "Creating directory /tmp/data, for mysql sorage."
sleep 2
mkdir /tmp/data
kubectl apply -f pv.yaml
sleep 1
kubectl apply -f pvc.yaml
sleep 1
kubectl apply -f secret.yaml
sleep 1
kubectl apply -f mysql-deployment.yaml
sleep 1
kubectl apply -f mysql-service.yaml
sleep 1
kubectl apply -f apache-php-deployment.yaml
sleep 1
kubectl apply -f apache-php-service.yaml
sleep 1
kubectl apply -f mysql-autoscaler.yaml
sleep 1
kubectl apply -f apache-php-autoscaler.yaml
sleep 1
echo "simple-k8s stack is now deployed"
