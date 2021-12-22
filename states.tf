###
# Depending on how you handle privledge escalation you will need to either uncomment line for role_arn
# or lines shared_credentials_file, and profile
# State files do now allow for variables.  So everything needs to be explicit.
###
#terraform {
  
#  backend "s3" {
#    region                 = "us-east-1"
#    bucket                 = "tester-mctesterson"
#    key                    = "stitchfix/work_assignment"
#    encrypt                = true
#   role_arn               = "arn:aws:iam::012345678912:role/MemberAdminRole"
#   shared_credentials_file = "~/.aws/config"
#   profile                 = "Adam_doing_stuff"
#  }
#}

