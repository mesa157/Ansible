#!/bin/bash

# Variables
code_directory="/path/to/code"
remote_server="<YOUR_REMOTE_SERVER>"
remote_user="<YOUR_REMOTE_USER>"
remote_code_directory="/path/to/remote/code"
remote_backup_directory="/path/to/remote/backup"
branch_name="master"

# Check if the local code is up-to-date
cd $code_directory
git fetch origin
if ! git diff --quiet origin/$branch_name; then
  echo "Local code is not up-to-date. Please update before deploying."
  exit 1
fi

# Get latest code from version control
git pull origin $branch_name

# Create a backup of the remote code
ssh $remote_user@$remote_server "tar -czf $remote_backup_directory/backup-$(date +%Y-%m-%d-%H-%M-%S).tar.gz $remote_code_directory"

# Stop the production server
ssh $remote_user@$remote_server "systemctl stop myserver"

# Copy new code to production server
scp -r $code_directory $remote_user@$remote_server:$remote_code_directory

# Check if the new code works as expected
ssh $remote_user@$remote_server "cd $remote_code_directory && ./run_tests.sh"
if [ $? -ne 0 ]; then
  echo "Tests failed. Restoring previous code version."
  # Restoring previous code version
  ssh $remote_user@$remote_server "tar -xzf $remote_backup_directory/backup-latest.tar.gz -C $remote_code_directory"
  ssh $remote_user@$remote_server "systemctl start myserver"
  exit 1
fi

# Start the production server
ssh $remote_user@$remote_server "systemctl start myserver"

# Notify the deployment was successful
echo "Deployment was successful."

