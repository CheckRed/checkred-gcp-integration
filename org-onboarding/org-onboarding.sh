echo $1
echo $2
export GOOGLE_CLOUD_PROJECT=$1
export CHECKRED_SERVICE_ACCOUNT_EMAIL=$2
gcloud services enable iamcredentials.googleapis.com --project $1
gcloud services enable cloudresourcemanager.googleapis.com --project $1
export ORG_ID=`gcloud projects get-ancestors $1 | grep organization | awk '{print $1;}'`
sed -i "s/PROJECT_ID/$1/g" versions.tf
sed -i "s/ORGANIZATION_ID/$ORG_ID/g" checkred_org_integration.tf
sed -i "s/CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL/$2/g" checkred_org_integration.tf
terraform init
terraform plan
terraform apply -auto-approve
