# DNS GCP Integration

## Project Setup

Google Cloud Platform organizes resources into projects.
Select your GCP project to integrate with Platform
<walkthrough-project-setup></walkthrough-project-setup>

<walkthrough-footnote>© 2023-24 All rights reserved</walkthrough-footnote>

## Enable IAM API for generating short-lived credentials & impersonating service accounts. 

NOTE: deploy.sh will create the Service account in your project. Please copy the output **service_account_email** from Cloud Shell console and paste into the GCP Impersonation account on platform

```bash
sh deploy.sh <walkthrough-project-id/> <SERVICE_ACCOUNT_EMAIL>
```

Click on **Copy to Cloud Shell** <walkthrough-cloud-shell-icon></walkthrough-cloud-shell-icon> button and replace the <SERVICE_ACCOUNT_EMAIL> with email address in the platform


<walkthrough-footnote>© 2023-24 All rights reserved</walkthrough-footnote>

## Congratulations

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You’re all set!

<walkthrough-footnote>© 2023-24 All rights reserved</walkthrough-footnote>
