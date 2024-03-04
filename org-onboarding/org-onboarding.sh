echo $1
echo $2
export PROJECT_ID=$1
export CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL=$2
gcloud services enable iamcredentials.googleapis.com --project $1
gcloud services enable cloudresourcemanager.googleapis.com --project $1
export ORG_ID=`gcloud projects get-ancestors $PROJECT_ID --format=json | jq -r '.[] | select(.type == "organization") | .id'`
sed -i "s/PROJECT_ID/$PROJECT_ID/g" versions.tf
sed -i "s/ORGANIZATION_ID/$ORG_ID/g" checkred_org_integration.tf
sed -i "s/CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL/$2/g" checkred_org_integration.tf
terraform init
terraform plan
terraform apply -auto-approve
