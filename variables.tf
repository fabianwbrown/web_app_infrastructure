variable "s3_bucket" {
  description = "s3 bucket for web app"
  type        = string
}

variable "dynamodb_webapp" {
  description = "dynamodb table for web app"
  type        = string
}

variable "dynamodb_State" {
  description = "dynamodb table for state file"
  type        = string
}

variable "iam_role_webapp" {
  description = "Iam roles"
  type        = string
}

variable "s3_bucket_state" {
  description = "s3 bucket for state file"
  type        = string
}

