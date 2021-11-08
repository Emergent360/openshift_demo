#!/bin/bash
CLUSTER_NAME=$1
BUILD_PATH="/home/ec2-user/$CLUSTER_NAME/build"


cat "$BUILD_PATH/auth/kubeconfig" | grep certificate-authority-data | awk '{print $2}' | base64 -d > "$BUILD_PATH/auth/kubeconfig-bundle.crt"
cat /home/ec2-user/.certbot/config/archive/api."$CLUSTER_NAME".lab-emergent360.com/chain1.pem >> "$BUILD_PATH/auth/kubeconfig-bundle.crt"
OLD_CERTS=$(cat "$BUILD_PATH/auth/kubeconfig" | grep certificate-authority-data | awk '{print $2}' | tr -d '\n')
NEW_CERTS=$(cat $BUILD_PATH/auth/kubeconfig-bundle.crt | base64 -w 0 | tr -d '\n')
sed -i "s|$OLD_CERTS|$NEW_CERTS|" "$BUILD_PATH/auth/kubeconfig"