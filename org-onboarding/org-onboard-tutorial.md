# GCP CSPM Organization Integration

## Project Setup

Google Cloud Platform organizes resources into projects.

Select your GCP project to integrate with the platform.

`<walkthrough-project-setup></walkthrough-project-setup>`

`<walkthrough-footnote>©   2023-24 All rights reserved</walkthrough-footnote>`

## Enable IAM API for Generating Short-Lived Credentials and Impersonating Service Accounts

**Note:** `org-onboarding.sh` will create the service account in your project.

Please copy the output **service_account_email** from the Cloud Shell console and paste it into the GCP Impersonation Account configuration on the platform.

```bash
cd org-onboarding && sh org-onboarding.sh <walkthrough-project-id/> <IMPERSONATION_SERVICE_ACCOUNT_EMAIL>
```

Click on the **Copy to Cloud Shell** <walkthrough-cloud-shell-icon></walkthrough-cloud-shell-icon> button and replace `<IMPERSONATION_SERVICE_ACCOUNT_EMAIL>` with the required impersonation service account email address.

`<walkthrough-footnote>©   2023-24 All rights reserved</walkthrough-footnote>`

## Congratulations

`<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>`

You're all set!

`<walkthrough-footnote>©   2023-24 All rights reserved</walkthrough-footnote>`