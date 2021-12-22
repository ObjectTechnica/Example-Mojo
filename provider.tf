###
# Depending on how you handle privledge escalation you will need to either uncomment line for role_arn and session_name
# or lines shared_credentials_file, and profile
###
provider "aws" {
    region                  = var.region
    #shared_credentials_file = "~/.aws/config"
    #profile                 = "object-technica-mp"
    assume_role {
    role_arn     =  "arn:aws:iam::${var.master_id}:role/MemberAdminRole"
    session_name = "adam-doing-stuff"
    }
        
        default_tags {
            tags = {
        Team       = "Infrastructure"
        Workload   = "ETL"
        CostCenter = "300-001"
        Contact    = "adam@gmail.com"
            }
        }
    
    endpoints {
        acm              = "https://acm-fips.${var.region}.amazonaws.com"
        acmpca           = "https://acm-pca-fips.${var.region}.amazonaws.com"
        accessanalyzer   = "https://access-analyzer-fips.${var.region}.amazonaws.com" 
        apigateway       = "https://apigateway-fips.${var.region}.amazonaws.com"
        appstream        = "https://appstream2-fips.${var.region}.amazonaws.com"
        athena           = "https://athena-fips.${var.region}.amazonaws.com"
        backup           = "https://backup-fips.${var.region}.amazonaws.com"
        batch            = "https://fips.batch.${var.region}.amazonaws.com"
        cloudformation   = "https://cloudformation-fips.${var.region}.amazonaws.com"
        cloudfront       = "https://cloudfront-fips.amazonaws.com"
        cloudtrail       = "https://cloudtrail-fips.${var.region}.amazonaws.com"
        cloudwatchevents = "https://events-fips.${var.region}.amazonaws.com"
        cloudwatchlogs   = "https://logs-fips.${var.region}.amazonaws.com"
        codebuild        = "https://codebuild-fips.${var.region}.amazonaws.com"
        codecommit       = "https://codecommit-fips.${var.region}.amazonaws.com"
        codedeploy       = "https://codedeploy-fips.${var.region}.amazonaws.com"
        codepipeline     = "https://codepipeline-fips.${var.region}.amazonaws.com" 
        cognitoidentity  = "https://cognito-identity-fips.${var.region}.amazonaws.com"
        cognitoidp       = "https://cognito-idp-fips.${var.region}.amazonaws.com"
        configservice    = "https://config-fips.${var.region}.amazonaws.com"
        datasync         = "https://datasync-fips.${var.region}.amazonaws.com"
        directconnect    = "https://directconnect-fips.${var.region}.amazonaws.com"
        detective        = "https://api.detective-fips.us-east-1.amazonaws.com" 
        dms              = "https://dms-fips.${var.region}.amazonaws.com"
        ds               = "https://ds-fips.${var.region}.amazonaws.com"
        dynamodb         = "https://dynamodb-fips.${var.region}.amazonaws.com"
        ec2              = "https://ec2-fips.${var.region}.amazonaws.com"
        ecr              = "https://ecr-fips.${var.region}.amazonaws.com"
        ecs              = "https://ecs-fips.${var.region}.amazonaws.com" 
        eks              = "https://fips.eks.${var.region}.amazonaws.com" 
        efs              = "https://elasticfilesystem-fips.${var.region}.amazonaws.com" 
        elasticache      = "https://elasticache-fips.${var.region}.amazonaws.com"
        elasticbeanstalk = "https://elasticbeanstalk-fips.${var.region}.amazonaws.com"
        elb              = "https://elasticloadbalancing-fips.${var.region}.amazonaws.com"
        emr              = "https://elasticmapreduce-fips.${var.region}.amazonaws.com"
        es               = "https://es-fips.${var.region}.amazonaws.com"
        fms              = "https://fms-fips.${var.region}.amazonaws.com"
        fsx              = "https://fsx-fips.${var.region}.amazonaws.com" 
        firehose         = "https://firehose-fips.${var.region}.amazonaws.com" 
        glacier          = "https://glacier-fips.${var.region}.amazonaws.com"
        glue             = "https://glue-fips.${var.region}.amazonaws.com" 
        guardduty        = "https://guardduty-fips.${var.region}.amazonaws.com"
        iam              = "https://iam-fips.amazonaws.com" 
        inspector        = "https://inspector-fips.${var.region}.amazonaws.com"
        kafka            = "https://kafka-fips.${var.region}.amazonaws.com"
        kinesis          = "https://kinesis-fips.${var.region}.amazonaws.com"
        kinesisanalytics = "https://kinesisanalytics-fips.${var.region}.amazonaws.com"
        kms              = "https://kms-fips.${var.region}.amazonaws.com"
        lambda           = "https://lambda-fips.${var.region}.amazonaws.com"
        licensemanager   = "https://license-manager-fips.${var.region}.amazonaws.com" 
        macie            = "https://macie-fips.${var.region}.amazonaws.com" 
        macie2           = "https://macie2-fips.${var.region}.amazonaws.com"
        medialive        = "https://medialive-fips.${var.region}.amazonaws.com" 
        mq               = "https://mq-fips.${var.region}.amazonaws.com"
        opsworks         = "https://opsworks-cm-fips.${var.region}.amazonaws.com" 
        organizations    = "https://organizations-fips.${var.region}.amazonaws.com" 
        pinpoint         = "https://pinpoint-fips.${var.region}.amazonaws.com"
        quicksight       = "https://fips-${var.region}.quicksight.aws.amazon.com"
        ram              = "https://resource-groups-fips.${var.region}.amazonaws.com" 
        rds              = "https://rds-fips.${var.region}.amazonaws.com"
        redshift         = "https://redshift-fips.${var.region}.amazonaws.com"
        resourcegroups   = "https://resource-groups-fips.${var.region}.amazonaws.com"
        route53          = "https://route53-fips.amazonaws.com"
        #s3               = "https://s3-fips.${var.region}.amazonaws.com"
        #Disabled due to "no such host" error on apply
        sagemaker        = "https://api-fips.sagemaker.${var.region}.amazonaws.com"
        secretsmanager   = "https://secretsmanager-fips.${var.region}.amazonaws.com"
        servicecatalog   = "https://servicecatalog-fips.${var.region}.amazonaws.com"
        ses              = "https://email-fips.${var.region}.amazonaws.com"
        shield           = "https://shield-fips.${var.region}.amazonaws.com"
        sns              = "https://sns-fips.${var.region}.amazonaws.com"        
        sqs              = "https://sqs-fips.${var.region}.amazonaws.com"
        ssm              = "https://ssm-fips.${var.region}.amazonaws.com"
        sts              = "https://sts-fips.${var.region}.amazonaws.com"
        storagegateway   = "https://storagegateway-fips.${var.region}.amazonaws.com"
        swf              = "https://swf-fips.${var.region}.amazonaws.com"
        transfer         = "https://transfer-fips.${var.region}.amazonaws.com" 
        waf              = "https://waf-fips.amazonaws.com"
        wafregional      = "https://waf-regional-fips.${var.region}.amazonaws.com"
        wafv2            = "https://wafv2-fips.${var.region}.amazonaws.com"
        xray             = "https://xray-fips.${var.region}.amazonaws.com" 
    }
}