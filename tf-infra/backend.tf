terraform {
  backend "s3" {
    bucket  = "tf-state-5dvpr-job-toolschain-e-emergingops"
    key     = "infraestrutura.tfstate"
    encrypt = "true"
    region  = "us-east-2"
  }
}  