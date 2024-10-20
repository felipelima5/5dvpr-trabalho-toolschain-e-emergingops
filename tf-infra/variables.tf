variable "region" {
  type    = string
  default = "us-east-2"
}

variable "bucket_name" {
  type    = string
  default = "bucket-frontend-5dvpr-delivery-homework-3569870"
}

variable "tags" {
  type    = map(string)
  default = {
    env = "prod"
    ManagedBy = "IaC"
  }
}