echo $1
echo $2
echo $3
echo $4
export PROJECT_ID=$1
export CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL=$2
gcloud services enable iamcredentials.googleapis.com --project $1
gcloud services enable cloudresourcemanager.googleapis.com --project $1
export ORG_ID=`gcloud projects get-ancestors $PROJECT_ID --format=json | jq -r '.[] | select(.type == "organization") | .id'`
sed -i "s/PROJECT_ID/$PROJECT_ID/g" versions.tf
sed -i "s/ORGANIZATION_ID/$ORG_ID/g" checkred.tf
sed -i "s/CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL/$2/g" checkred.tf
ENABLE_CSPM=$([ "$3" == CSPM_YES ] && echo "true" || echo "false")
ENABLE_DNSPM=$([ "$4" == DNSPM_YES ] && echo "true" || echo "false")
echo $ENABLE_CSPM
echo $ENABLE_DNSPM
terraform init
terraform plan -var="enable_cspm=$ENABLE_CSPM" -var="enable_dnspm=$ENABLE_DNSPM"
terraform apply -auto-approve -var="enable_cspm=$ENABLE_CSPM" -var="enable_dnspm=$ENABLE_DNSPM"
