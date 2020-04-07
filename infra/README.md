# Infrastructure

This directory holds the code to provision the infrastructure of Mirage Demo.

## Getting started

First things first, you need to create create a GCP project.
You can use the script `init-gcloud.sh` for this, you just need to create a variable with your billing account ID:

```bash
export GCP_BILLING_ACOUNT_ID=XXXXXX-XXXXXX-XXXXXX
```

The script will perform the following actions:

- Create a new project
- Create a service account for Terraform and save the credentials in `accounts.json`
- Set the appropriate permissions to the terrafom service account
- Create a Storage bucket to store our terraform state

Once you've done that, you can rely on terraform to provision the rest of your infrastructure.

There are two part of the infrastructure:

- `global`, provisionning general resources.
- `instance`, provisionning resources specific to the instance running the unikernel.

When you're creating the project, you would typically follow the next steps.

### Provision `global`

In `infra/global`, you can run:

```bash
# Check that everything is ok
terraform plan
# And deploy!
terraform deploy
```

When the deployment is done, you will need the output to create Github secrets. Add the following secrets to your repository's secrets:

- `GCE_PROJECT`: Google Cloud project ID (this should be `mirage-demo`)
- `GCE_SA_EMAIL`: The email of the service account, this is `github-actions-email` in terrafom's output.
- `GCE_SA_KEY`: The content of the service account JSON file, this is `github-actions-private-key` in terrafom's output.

### Deploy a first image

The instance needs an image to be deployed. This will be managed by the CI/CD once you're setup, but you need to publish the first image manually.

At the root of the project:

```bash
# Built the image
./script/build.sh

# Upload the file to Google Compute Storage 
gsutil cp mirage-demo-latest.tar.gz gs://mirage-images
```

### Provision `instance`

When you have your first image pushed in Google Storage, you can provision the resources to run your unikernel. In `infra/instance`:

```bash
# Check that everything is ok
terraform plan
# And deploy!
terraform deploy
```

In the output, you should see the public IP attributed to your instance.