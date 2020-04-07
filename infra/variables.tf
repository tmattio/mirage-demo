variable "region" {
  description = "The region where the environment will be provisioned on."
  default     = "us-east1"
}

variable "zone" {
  description = "The zone where the environment will be provisioned on."
  default     = "us-east1-b"
}

variable "project_id" {
  description = "The project ID to deploy the infrastructure to."
  default     = "mirage-demo-273420"
}
