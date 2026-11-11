set -e

TERRAFORM_VERSION="1.9.8"
export PATH="$HOME/.local/bin:$PATH"

ensure_terraform() {
  if terraform version 2>/dev/null | grep -q '^Terraform v'; then
    return
  fi
  echo "Terraform not found, installing v${TERRAFORM_VERSION} to $HOME/.local/bin"
  case "$(uname -m)" in
    x86_64) tf_arch="amd64" ;;
    aarch64|arm64) tf_arch="arm64" ;;
    *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
  esac
  tf_zip="terraform_${TERRAFORM_VERSION}_linux_${tf_arch}.zip"
  tf_url="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}"
  tmp_dir="$(mktemp -d)"
  curl -fsSL -o "$tmp_dir/$tf_zip" "$tf_url/$tf_zip"
  curl -fsSL -o "$tmp_dir/SHA256SUMS" "$tf_url/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
  (cd "$tmp_dir" && grep " $tf_zip\$" SHA256SUMS | sha256sum -c -)
  mkdir -p "$HOME/.local/bin"
  unzip -o -q "$tmp_dir/$tf_zip" terraform -d "$HOME/.local/bin"
  rm -rf "$tmp_dir"
  terraform version
}

echo $1
echo $2
export GOOGLE_CLOUD_PROJECT=$1
export CHECKRED_SERVICE_ACCOUNT_EMAIL=$2
gcloud services enable iamcredentials.googleapis.com --project $1
gcloud services enable cloudresourcemanager.googleapis.com --project $1
sed -i "s/PROJECT_ID/$1/g" checkred.tf
sed -i "s/CHECKRED_SERVICE_ACCOUNT_EMAIL/$2/g" checkred.tf
ensure_terraform
terraform init
terraform plan
terraform apply -auto-approve
