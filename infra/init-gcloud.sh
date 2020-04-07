#!/bin/sh

set -e

GCP_PROJECT=mirage-demo-273420

# Create a GCP project
gcloud projects create --name ${GCP_PROJECT}

# Setup the billing account for this project
gcloud beta billing projects link ${GCP_PROJECT} \
  --billing-account ${GCP_BILLING_ACOUNT_ID}

# Create a service account for Terrafom.
gcloud iam service-accounts create terraform-admin \
    --description "A service account used by Terraform to provision the infrastructure." \
    --display-name "Terraform Admin" \
    --project=${GCP_PROJECT}

gcloud iam service-accounts keys create account.json \
  --iam-account=terraform-admin@${GCP_PROJECT}.iam.gserviceaccount.com \
  --project=${GCP_PROJECT}

gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
  --member serviceAccount:terraform-admin@${GCP_PROJECT}.iam.gserviceaccount.com \
  --role roles/owner

# Create a bucket to store our terrafom state
gsutil mb -p ${GCP_PROJECT} -l us-east1 gs://${GCP_PROJECT}-tfstate
