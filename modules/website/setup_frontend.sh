#!/bin/bash

# Variables
TMP_DIR="/tmp"
REPO_URL="https://github.com/PacktPublishing/AWS-Cloud-Projects.git"
FRONTEND_DIR="$TMP_DIR/chapter7/code/frontend"
CONFIGS_DIR="$FRONTEND_DIR/src/configs"

# 1️⃣ Récupérer la région AWS depuis Terraform
AWS_REGION=$(terraform output -raw region)

# Vérification de la région
if [ -z "$AWS_REGION" ]; then
  echo "❌ La région AWS n'a pas été définie. Assurez-vous que la variable 'region' est bien configurée dans Terraform."
  exit 1
fi

echo "🌍 Région AWS détectée : $AWS_REGION"

# 2️⃣ Cloner le dépôt GitHub si non déjà présent
if [ ! -d "$TMP_DIR" ]; then
  echo "📥 Clonage du dépôt GitHub..."
  git clone $REPO_URL $TMP_DIR
else
  echo "🔄 Mise à jour du dépôt GitHub..."
  git -C $TMP_DIR pull
fi

# 3️⃣ Créer le dossier configs si non existant
mkdir -p $CONFIGS_DIR

# 4️⃣ Récupérer les outputs de Terraform
API_URL=$(terraform output -raw api_url)
CLIENT_ID=$(terraform output -raw user_pool_client_id)
USER_POOL_ID=$(terraform output -raw user_pool_id)
BUCKET_NAME=$(terraform output -raw bucket_name)

# Vérification des valeurs récupérées
if [ -z "$API_URL" ] || [ -z "$CLIENT_ID" ] || [ -z "$USER_POOL_ID" ] || [ -z "$BUCKET_NAME" ]; then
  echo "❌ Impossible de récupérer certains outputs Terraform. Vérifiez vos ressources."
  exit 1
fi

# 5️⃣ Générer le fichier configs.tsx
cat <<EOL > $CONFIGS_DIR/configs.tsx
export const API_URL = '${API_URL}';
EOL

# 6️⃣ Générer le fichier aws-exports.ts
cat <<EOL > $CONFIGS_DIR/aws-exports.ts
export const amplifyConfig = {
  aws_project_region: '${AWS_REGION}',
  aws_cognito_region: '${AWS_REGION}',
  aws_user_pools_id: '${USER_POOL_ID}',
  aws_user_pools_web_client_id: '${CLIENT_ID}'
};
EOL

# 7️⃣ Build du frontend
echo "⚙️ Installation des dépendances et build du projet..."
cd $FRONTEND_DIR
npm install
npm run build

# 8️⃣ Déploiement sur S3
echo "🚀 Déploiement sur S3..."
aws s3 sync dist s3://$BUCKET_NAME --delete --region $AWS_REGION

# 9️⃣ Affichage de l'URL finale
echo "✅ Déploiement terminé sur S3 :"
echo "🌐 http://${BUCKET_NAME}.s3-website-${AWS_REGION}.amazonaws.com"