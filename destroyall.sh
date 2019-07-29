#!/bin/bash
kubectl delete deployment apache-php
kubectl delete deployment mysql
kubectl delete pvc mysql-storage-claim
kubectl delete pv mysql-storage
kubectl delete service apache-php
kubectl delete service mysql
kubectl delete secret mysql-password
kubectl delete horizontalpodautoscaler apache-php
kubectl delete horizontalpodautoscaler mysql
rm -rf /tmp/data
echo "/tmp/data deleted"
