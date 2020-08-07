#!/bin/bash

PRIVATE_KEY="~/.ssh/privkey.pem"

echo "
#######
# Terminating instance...
#######
"
SFR_ID=$(head terraform.tfstate | egrep -oh "(sfr)-[a-z0-9-]{36}")
SFR_INSTANCE_INFO=$(aws ec2 describe-spot-fleet-instances --spot-fleet-request-id $SFR_ID)
INSTANCE_ID=$(echo $SFR_INSTANCE_INFO | egrep -oh "(i)-[a-z0-9]{17}")

aws ec2 terminate-instances --instance-ids $INSTANCE_ID

echo "
#######
# Command sent! Now removing data in terraform.tfstate
#######
"

cdktf destroy --auto-approve
