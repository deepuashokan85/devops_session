provider "aws" {
  # Credentials to access aws cluster
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}
