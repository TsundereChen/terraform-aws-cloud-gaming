#!/bin/bash

PRIVATE_KEY="~/.ssh/privkey.pem"

echo "
#######
# Terminating instance...
#######
"
SFR_ID=$(head -n 10 terraform.tfstate | egrep -oh "(sfr)-[a-z0-9-]{36}")

TERMINATE_MESSAGE=$(aws ec2 cancel-spot-fleet-requests --spot-fleet-request-ids $SFR_ID --terminate-instances)

echo "
#######
# Command sent! Now termiating...
#######
"

