# StitchFix ETL work assignment
## _Prove I can do what I say I can do, and keep security in mind_

[![N|Solid](https://hashicorp.github.io/field-workshops-terraform/slides/aws/terraform-cloud/images/tf_aws.png)](https://hashicorp.github.io/field-workshops-terraform/slides/aws/terraform-cloud/images/tf_aws.png)

## Terraform approach
The current StitchFix ETL work assignment setup to perform the following:
- In the same AWS region, create 2 VPCs with the S3 Gateway endpoint enabled. 
- VPC peering should allow private connectivity between the two VPCs.
- Create a Postgres leader instance in VPC1 and a replica/follower instance in VPC2.
- Store the database credentials so they can be viewed from the AWS Console or CLI when admin/elevated privileges are used.
- Create an S3 bucket that may be needed for a future EC2 bulk load process.
- Ensure an IAM role exists with access to the S3 bucket you create. 

## Architecture Assumptions
###### _The following assumptions were made regarding the preferred architecture, and deployment/operational methodologies: _
- Terraform version 15.5 is currently being used for this work assignment
- There were no enviornment variables set, other than the key/secret used to assume the role listed in the provider.tf.  everything was called out in their respective variables.tf
- An existing AWS account, within an existing AWS organization was used for this work assignment.  If a new account creation was requested, the provider.tf would have been updated to include a provider alias for bootstrapping the account holding this work assignment. Additional modules would also be added for OU and SCP creation, as well as AWS commercial account creation.
- When you create a new AWS account, you have the option of also creating an admin role for that new account.  This provider.tf is leveraging that role within the AWS Organization I am using for this work assignment.  Other inactive options within the provider.tf include assigning access via "AWS_PROFILE" key/secret
- AWS Secrets manager has a deletion window of 0.  If this were anything more than a take home assignment that value would be increased.
- Specific subnets within each of the two VPC's for peering were not specified.  Since
- Since there was no mention of an EC2 instance in the work assignment, only the subnets where the primary and replica database live were added to the VPC peering connection.
- To be cost effective only a single NAT Gateway is being used for all of the private subnets.
- To be security concious, no NAT Gateway has been deployed with the database subnets.  There should be no reason your DB's call out to the internet.
- Both the KMS CMK and the S3 Bucket policy leverage an existing IAM role.  Since the ask was to "Ensure an IAM role exists" and not "create new IAM role" I utilized an existing role.  This role can be verified in the KMS Key policy as well as the S3 bucket policy.  
    - You cannot administer the KMS CMK if you cannot assume that role
    - You cannot interact with the S3 bucket if you cannot assume the role

## Architecture Exceptions
- Secrets Manager username and password are visible in state file.  This is an open issue with hashicorp.  Available work aroundis to tightly control your remote state backend, and enforce encryption.
```
https://github.com/hashicorp/terraform/issues/516
```
- Known issues when dealing with AWS RDS and Terraform
when running a destroy the RDS instances will throw errors these are documented issues via Hashicorp
 the "skip_final_snaphot" and the "final_snapshot_identifier" never get read in properly and destroys fail.  we can add the replica manually, destroy the instances manually or skip the replica creation and increate backup retentions on primary.  This issue is still open and pending.
-- A possible work around would be to statically assign AZ's on deployment, but that’s not possible when you are setting “multi-az = true”
 ```
https://github.com/hashicorp/terraform/issues/5417
https://github.com/hashicorp/terraform-provider-aws/issues/9760
https://github.com/hashicorp/terraform-provider-aws/issues/2588
```

## Terraform execution plan
```
Terraform init
```
Used to initialize a working directory containing Terraform configuration files
```
Terraform plan
```
Used to create an execution plan
```
Terraform apply
```
executes the actions proposed in a Terraform plan.

