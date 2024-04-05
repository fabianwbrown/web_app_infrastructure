# web_app_infrastructure
HW March 31,2024
Challenge: Basic Web Application Infrastructure Setup with Terraform
Objective:
Design and implement a Terraform configuration to set up infrastructure for hosting a basic web application on AWS. This setup will include S3 buckets for static assets, a DynamoDB table for data storage, IAM roles with tailored permissions for resource access, and remote state management for collaboration.
Requirements:
Variables and Outputs:
Define variables for the S3 bucket name, DynamoDB table name, and IAM role names.✅
Output the ARNs of the IAM roles and the names of the S3 bucket and DynamoDB table.
S3 Bucket Setup:
Create an S3 bucket with versioning enabled for storing static web application assets. Ensure the bucket is private.✅
DynamoDB Table Setup:
Implement a DynamoDB table for storing application data. Choose suitable attributes and keys based on a simple web application data model.✅
IAM Policies and Roles:
Define IAM policies that specify read-write access to the S3 bucket and DynamoDB table.
Create IAM roles and attach the policies to them.✅
Remote State Management:
Configure an S3 bucket for storing the Terraform state file. Enable versioning and encryption for security.
Use a DynamoDB table for state locking to prevent concurrent state modifications.✅

