terraform {
  backend "s3" {
    bucket = "ta-tf-st"
    key    = "workspace/terraform.tfstate"
    profile = "skillmix-lab"
    region = "us-west-2"
  }
}
