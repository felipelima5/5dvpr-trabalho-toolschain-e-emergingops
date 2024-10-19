terraform {
  backend "s3" {
    bucket  = "tf-state-5dvpr-trabalho-toolschain-e-emergingops"
    key     = "infra.tfstate"
    encrypt = "true"
    region  = "us-east-2"
  }
}  