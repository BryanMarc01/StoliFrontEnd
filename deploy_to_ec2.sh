#!/bin/bash

# Asegúrate de que el script se detenga si ocurre algún error
set -e

# Variables de configuración
SERVER_USER="ubuntu"
SERVER_IP="3.141.189.187"
PEM_KEY_PATH="/tmp/deploy_key.pem"
ECR_REPOSITORY_URI="public.ecr.aws/d3s5l7i0/frontend"

# Inicia sesión en Docker y actualiza los contenedores
ssh -o StrictHostKeyChecking=no -i $PEM_KEY_PATH $SERVER_USER@$SERVER_IP << 'EOF'
  export PATH=$PATH:/usr/local/bin:/usr/bin
  /usr/local/bin/aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
  /usr/local/bin/aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
  /usr/local/bin/aws configure set default.region $AWS_REGION
  /usr/local/bin/aws ecr-public get-login-password --region us-east-1 | /usr/bin/docker login --username AWS --password-stdin public.ecr.aws
  /usr/bin/docker pull public.ecr.aws/d3s5l7i0/frontend:latest
  /usr/bin/docker stop frontend || true
  /usr/bin/docker rm frontend || true
  /usr/bin/docker run -d --name frontend -p 3000:3000 public.ecr.aws/d3s5l7i0/frontend:latest
EOF

echo "Despliegue completado exitosamente."
