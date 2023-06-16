terraform {
  backend "s3" {
    bucket = "tien-test-terraform"
    dynamodb_table = "tien-test-dynamodb"
  }
}
