#!/bin/bash

# Asegúrate de que el script se detenga si ocurre algún error
set -e

export PATH="/snap/bin:/usr/bin:$PATH"
echo "DEBUG: PATH is $PATH"
which aws
which docker
# Variables de configuración
SERVER_USER="ubuntu"
SERVER_IP="3.141.189.187"
PEM_KEY_PATH="/tmp/deploy_key.pem"
ECR_REPOSITORY_URI="public.ecr.aws/d3s5l7i0/frontend"



# Inicia sesión en Docker y actualiza los contenedores
ssh -o StrictHostKeyChecking=no -i $PEM_KEY_PATH $SERVER_USER@$SERVER_IP << EOF
  aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
  aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
  aws configure set default.region $AWS_REGION
  aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
  docker pull public.ecr.aws/d3s5l7i0/frontend:latest
  docker stop frontend || true
  docker rm frontend || true
  docker run -d --name frontend -p 3000:3000 public.ecr.aws/d3s5l7i0/frontend:latest
EOF

echo "Despliegue completado exitosamente"