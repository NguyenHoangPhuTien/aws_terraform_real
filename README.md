# SETUP TERRAFORM FOR RUNNING

## Terraform Installation

Follow this [instruction] [Homebrew]

Terraform version: v1.4.6

## Terraform S3 + Dynammo Backend

![alt text](https://1.bp.blogspot.com/-bLOe3OqBoEc/YJ1LlWxQ1dI/AAAAAAAADcE/T4geWTfckMMfQbhq-ElfjVZtbd8Mv-e-QCLcBGAsYHQ/s1094/tf%2Bstate%2Busing%2Bs3.png)

### S3

Create new bucket and enable versioning for this bucket. Example: tien-test-terraform

Refer: [S3 Versioning]

### Dynamo

Create new Dyanmo table with partion key is LockID (type: string). Example: tien-test-dynamodb

Refer: [Dynamo]

### Create/update backend.tf

Example: update the backend for hippa project in the path: projects/hippa/backend.tf

```bash
terraform {
  backend "s3" {
    bucket = "tien-test-terraform"
    dynamodb_table = "tien-test-dynamodb"
  }
}
```
## AWS setup

### Create IAM user

Example: create terraform user

Refer: [IAM User]

### Create IAM Role

Currently, we only need to create AWS resources for us-east-2 region. So, we only grant permission for creating resources in this region

Example: create terraform-authorized policy and terraform role. After that, we attach terraform-authorized policy to terraform role.

Note: we need to add terraform user to Trust releationships to terraform role

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement2",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<account_id>:user/terraform"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

Refer aws_policy.json file to review the policies

### Setup AWS Creds in local or instance

We need to add AWS creds into $HOME/.aws/credentials file

Example: we need to add my-account-terraform profile for including credentials

```bash
[my-account-terraform]
aws_access_key_id=xxxxxxx
aws_secret_access_key=xxxxxxxx
```

### Terraform for running

#### Terraform init

##### Purpose:

1. Setup backend: S3 (store state file) + DynamoDB (lock state).

2. Download provider(s) binary. Example: aws provider. Refer providers.tf

3. Install module(s)

##### Command:

Example: we need to run terraform code for hippa project

```bash
cd ./projects/hippa
terraform init \
    -backend-config="key=hippa/prod/terraform.tfstate" \
    -backend-config="region=us-east-2" \
    -backend-config="shared_credentials_file=~/.aws/credentials" \
    -backend-config="profile=my-account-terraform" \
    -backend-config="role_arn=arn:aws:iam::<account_id>:role/terraform"
```

Arguments:

1. key: the path to the state file inside the S3 Bucket.

2. region: AWS Region of the S3 Bucket and DynamoDB Table.

3. shared_credentials_file: path to the AWS shared credentials file.

4. profile: name of AWS profile in AWS shared credentials file.

5. role_arn: Amazon Resource Name (ARN) of the IAM Role to assume.

#### Terraform plan

##### Purpose:

1. The terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. By default, when Terraform creates a plan it

##### Command:

```bash
cd ./projects/hippa
export TF_VAR_assume_role=arn:aws:iam::<account_id>:role/terraform
export TF_VAR_region=us-east-2
export TF_VAR_profile=my-account-terraform
terraform plan -var-file="../../environments/prod/hippa.tfvars"
```

Arguments:

1. assume_role: mazon Resource Name (ARN) of the IAM Role to assume.

2. region: AWS Region of resources for creating.

3. profile: name of AWS profile in AWS credentials file.

#### Terraform apply

##### Purpose:

1. The terraform apply command executes the actions proposed in a Terraform plan.

```bash
cd ./projects/hippa
export TF_VAR_assume_role=arn:aws:iam::<account_id>:role/terraform
export TF_VAR_region=us-east-2
export TF_VAR_profile=my-account-terraform
terraform apply -var-file="../../environments/prod/hippa.tfvars" -auto-approve
```

Note:

1. We always need to run terraform plan first. Based on that, you can review the changes (add/update/destroy) of resources.

2. If we already run terraform plan first. No need to run export TF_VAR_assume_role, TF_VAR_region, TF_VAR_profile agin. Just run apply command.

#### Terraform destroy

##### Purpose:

1. The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.


##### Command:

```bash
cd ./projects/hippa
export TF_VAR_assume_role=arn:aws:iam::<account_id>:role/terraform
export TF_VAR_region=us-east-2
export TF_VAR_profile=my-account-terraform
terraform plan -destroy -var-file="../../environments/prod/hippa.tfvars"
terraform apply -destroy -var-file="../../environments/prod/hippa.tfvars" -auto-approve
```

Note:

1. We always need to run terraform plan -destroy first. Based on that, you can review the changes (the resources will be destroyed).

2. If we already run terraform plan -destroy first. No need to run export TF_VAR_assume_role, TF_VAR_region, TF_VAR_profile agin. Just run apply -destroy command.

[Terraform Installation]: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
[Terraform S3 + Dynamo Backend]: https://developer.hashicorp.com/terraform/language/settings/backends/s3
[S3 Versioning]: https://www.learnaws.org/2022/07/02/enable-s3-versioning/
[Dynamo]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/getting-started-step-1.html
[IAM User]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html