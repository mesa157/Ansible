!/bin/bash

# Gather instance metadata
instance_id=$( sudo curl -s http://169.254.169.254/latest/meta-data/instance-id)
public_ip=$( sudo curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
private_ip=$( sudo curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
security_groups=$( sudo curl -s http://169.254.169.254/latest/meta-data/security-groups)
os_name=$( sudo grep -oP '(?<=^NAME=).*' /etc/os-release)
os_version=$( sudo grep -oP '(?<=^VERSION=).*' /etc/os-release)

users=$( sudo grep -oP '^\w+' /etc/passwd)

# Create data file
data_file="instance_data.txt"
echo "Instance ID: $instance_id" > $data_file
echo "Public IP: $public_ip" >> $data_file
echo "Private IP: $private_ip" >> $data_file
echo "Security Groups: $security_groups" >> $data_file
echo "Operating System: $os_name $os_version" >> $data_file
echo "Users: $users" >> $data_file

# Install AWS CLI
sudo apt-get update -y
sudo apt-get install -y awscli
aws s3 cp $data_file s3://folder/role/

