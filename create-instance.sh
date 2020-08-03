#!/bin/bash

PRIVATE_KEY="~/.ssh/privkey.pem"

echo "
#######
# Creating instance...
#######
"

cdktf deploy --auto-approve

echo "
#######
# Create completed! Now fetching public IPv4 address
#######"

SFR_ID=$(head -n 10 terraform.tfstate | egrep -oh "(sfr)-[a-z0-9-]{36}")
INSTANCE_ID=$(aws ec2 describe-spot-fleet-instances --spot-fleet-request-id $SFR_ID | egrep -oh "(i)-[0-9a-z]{17}")
INSTANCE_PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName')

echo
echo "# Public DNS => $INSTANCE_PUBLIC_DNS"

echo "
#######
# Sleep 4 minutes before fetching the password
#######
"

sleep 240;

echo "
#######
# Now fetching Administrator password
#######"

echo "# Password => $(aws ec2 get-password-data --instance-id $INSTANCE_ID --priv-launch-key $PRIVATE_KEY | jq '.PasswordData')"


echo "
#######
# Please use password above to log into Windows using RDP
# Install Parsec and GPU drivers using this script
#

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$ScriptWebArchive = "https://github.com/parsec-cloud/Parsec-Cloud-Preparation-Tool/archive/master.zip"
$LocalArchivePath = "$ENV:UserProfile\Downloads\Parsec-Cloud-Preparation-Tool"
(New-Object System.Net.WebClient).DownloadFile($ScriptWebArchive, "$LocalArchivePath.zip")
Expand-Archive "$LocalArchivePath.zip" -DestinationPath $LocalArchivePath -Force
CD $LocalArchivePath\Parsec-Cloud-Preparation-Tool-master\ | powershell.exe .\loader.ps1

#
# You're going to need new AWS access key & private key, now generating...
#######"

echo "# Access Key & Secret Key => $(aws iam create-access-key)"

echo "
#######
# Insert your access key & secret key when asked in instance.
#######"

echo "
#######
# 1. Remember to format instance store, which comes with this instance type. This will give you 120G of storage
# 2. Download speed is limited to 20MB/s by AWS
# 3. Spot instances is billed hourly, so when done gaming, remember to shutdown and terminate your instance and spot request
#    You can use 'terminate-instance.sh' script to do this.
# 4. Enjoy!
#######"
