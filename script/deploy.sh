#!/bin/sh

set -e

GCP_PROJECT=mirage-demo-273420

# Upload the file to Google Compute Storage 
gsutil cp mirage-demo-latest.tar.gz gs://mirage-demo-273420-images

# Delete the image if it exists
gcloud compute images delete mirage-demo-latest \
    --quiet \
    --project=${GCP_PROJECT} || true

# Create an image from the new latest file
gcloud compute images create mirage-demo-latest \
    --source-uri gs://mirage-images/mirage-demo-latest.tar.gz \
    --family mirage-demo \
    --project=${GCP_PROJECT}

gcloud compute instance-groups managed rolling-action start-update mirage-demo-igm
    --version template=mirage-demo-template
