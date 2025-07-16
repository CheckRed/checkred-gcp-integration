# checkred-gcp-integration
CheckRed CSPM & DNSPM GCP Integration for GCP 1-Click deployment 

## Project Setup

Google Cloud Platform organizes resources into projects.

If you don't have project ready, [Create a new project](https://developers.google.com/workspace/guides/create-project) to ensure that you have the permissions you needed, or select an existing project in which you have the relevant permissions to integrate with CheckRed Platform.

## Enable IAM API for generating short-lived credentials & impersonating service accounts. 

NOTE: org-onboarding.sh will create the Service account in your project.

Please copy the output **service_account_email** from Cloud Shell console and paste into the CheckRed GCP Impersonation account on CheckRed platform
Organization Onboarding for DNSPM
```bash
sh org-onboarding.sh <GCP_PROJECT_ID> <CHECKRED_SERVICE_ACCOUNT_EMAIL> CSPM_NO DNSPM_YES
```
Organization onboarding for both CSPM AND DNSPM
```bash
sh org-onboarding.sh <GCP_PROJECT_ID> <CHECKRED_SERVICE_ACCOUNT_EMAIL> CSPM_YES DNSPM_YES
```

Please replace the <GCP_PROJECT_ID> and <CHECKRED_SERVICE_ACCOUNT_EMAIL> with your GCP Project ID and CheckRed impersonation service account email address.



## Congratulations

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You’re all set!

<walkthrough-footnote>© 2025-26 CheckRed All rights reserved</walkthrough-footnote>
