#!/bin/bash

# Default tfvars file
tfvars_file="./terraform.tfvars"

# Parse command line options
while getopts ":f:" opt; do
  case ${opt} in
    f)
      tfvars_file="$OPTARG"
      ;;
    \?)
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    :)
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done
shift $((OPTIND -1))

# Check if tfvars file exists
if [ ! -f "$tfvars_file" ]
then
    echo "$tfvars_file file not found. Exiting."
    exit 1
fi

# Extract the required variables from tfvars file
AWS_ACCESS_KEY=$(grep "^AWS_ACCESS_KEY" $tfvars_file | awk -F "=" '{print $2}' | tr -d ' "')
AWS_SECRET_KEY=$(grep "^AWS_SECRET_KEY" $tfvars_file | awk -F "=" '{print $2}' | tr -d ' "')
AWS_REGION=$(grep "^AWS_REGION" $tfvars_file | awk -F "=" '{print $2}' | tr -d ' "')

# Check if variables were extracted successfully
if [ -z "$AWS_ACCESS_KEY" ] || [ -z "$AWS_SECRET_KEY" ] || [ -z "$AWS_REGION" ]
then
    echo "Could not extract all required variables from $tfvars_file. Exiting."
    exit 1
fi

# Run terraform init with the extracted variables
terraform init \
            -backend-config="access_key=$AWS_ACCESS_KEY" \
            -backend-config="secret_key=$AWS_SECRET_KEY" \
            -backend-config="region=$AWS_REGION"
