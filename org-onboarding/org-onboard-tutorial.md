# CheckRed's CSPM GCP Organization Integration

## Project Setup

Google Cloud Platform organizes resources into projects.
Select your GCP project to integrate with CheckRed Platform
<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>© 2023-24 CheckRed All rights reserved</walkthrough-footnote>

## Enable IAM API for generating short-lived credentials & impersonating service accounts. 

NOTE: org-onboading.sh will create the Service account in your project. Please copy the output **service_account_email** from Cloud Shell console and paste into the CheckRed GCP Impersonation account on CheckRed platform

```bash
sh org-onboading.sh <walkthrough-project-id/> <CHECKRED_SERVICE_ACCOUNT_EMAIL>
```

Click on **Copy to Cloud Shell** <walkthrough-cloud-shell-icon></walkthrough-cloud-shell-icon> button and replace the <CHECKRED_SERVICE_ACCOUNT_EMAIL> with CheckRed email address 


<walkthrough-footnote>© 2023-24 CheckRed All rights reserved</walkthrough-footnote>

## Congratulations

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You’re all set!

<walkthrough-footnote>© 2023-24 CheckRed All rights reserved</walkthrough-footnote>
