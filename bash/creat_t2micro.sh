#!/bin/bash

# Variables
aws_access_key="<YOUR_ACCESS_KEY>"
aws_secret_key="<YOUR_SECRET_KEY>"
region="<YOUR_REGION>"
image_id="<YOUR_IMAGE_ID>"
instance_type="t2.micro"
security_group="<YOUR_SECURITY_GROUP>"
key_name="<YOUR_KEY_NAME>"
instance_name="myinstance"

# Provision new server
aws ec2 run-instances --region $region --image-id $image_id --count 1 --instance-type $instance_type --key-name $key_name --security-group-ids $security_group --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" --query 'Instances[0].InstanceId' --output text --profile $aws_access_key $aws_secret_key

