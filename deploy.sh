echo $1
echo $2
export GOOGLE_CLOUD_PROJECT=$1
export CHECKRED_SERVICE_ACCOUNT_EMAIL=$2
gcloud services enable iamcredentials.googleapis.com --project $1
sed -i "s/PROJECT_ID/$1/g" checkred.tf
sed -i "s/CHECKRED_SERVICE_ACCOUNT_EMAIL/$2/g" checkred.tf
terraform init
terraform plan
terraform apply -auto-approve
