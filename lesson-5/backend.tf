terraform {
  backend "s3" {
    bucket         = "serhii-lesson-5-tfstate-679626270053"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
