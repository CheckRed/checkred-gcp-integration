# CheckRed's CSPM GCP Integration

## Project Setup

Google Cloud Platform organizes resources into projects.

Select your GCP project to integrate with CheckRed Platform

<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>© 2023-24 CheckRed All rights reserved</walkthrough-footnote>

## Prerequisite: Check Terraform is installed

Before running the onboarding script, verify Terraform is available:

```bash
terraform --version
```

If the command returns Terraform v1.17.1, your environment is ready — proceed to "Download Terraform script". If it returns an older version, "command not found" or install instructions, Terraform needs to be installed or upgraded. Run the commands below to install it into your home directory:

**Commands**:

```bash
TF_VERSION="1.17.1"
mkdir -p ~/bin
curl -fsSLO "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
unzip -o "terraform_${TF_VERSION}_linux_amd64.zip" terraform
mv -f terraform ~/bin/
chmod +x ~/bin/terraform
rm -f "terraform_${TF_VERSION}_linux_amd64.zip"
grep -qxF 'export PATH="$HOME/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/bin:$PATH"
hash -r
terraform --version
```

## Enable IAM API for generating short-lived credentials & impersonating service accounts.

NOTE: deploy.sh will create the Service account in your project. Please copy the output **service_account_email** from Cloud Shell console and paste into the CheckRed GCP Impersonation account on CheckRed platform

```bash
sh deploy.sh <walkthrough-project-id/> <CHECKRED_SERVICE_ACCOUNT_EMAIL>
```

Click on **Copy to Cloud Shell** <walkthrough-cloud-shell-icon></walkthrough-cloud-shell-icon> button and replace the <CHECKRED_SERVICE_ACCOUNT_EMAIL> with CheckRed email address

<walkthrough-footnote>© 2023-24 CheckRed All rights reserved</walkthrough-footnote>

## Congratulations

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You're all set!

<walkthrough-footnote>© 2023-24 CheckRed All rights reserved</walkthrough-footnote>
