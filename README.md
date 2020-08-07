# terraform-aws-cloud-gaming

## Requirements
* AWS account
* `awscli` configured in your environment
* Terraform CDK
* jq

## Steps
* Copy `example.ts` to `main.ts`, then fill your informations, like
    * IAM role
      It should looks like this `arn:aws:iam::<ID>:role/aws-service-role/spotfleet.amazonaws.com/AWSServiceRoleForEC2SpotFleet`
    * Private key name
    * Security group ID
* Then specify your key's location in `create-instance.sh`
* Run `create-instance.sh`
* When done gaming, run `terminate-instance.sh` to terminate instance and remove spot fleet request

## TODO-automation
* Run [Parsec-Cloud-Preparation-Tool](https://github.com/parsec-cloud/Parsec-Cloud-Preparation-Tool) in the created instance
* Log into Parsec
* Install Steam
* Create partition in instance store
