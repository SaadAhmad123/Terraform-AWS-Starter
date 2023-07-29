#!/bin/bash

# Initialize our own variables
environment=""
file_location="./terraform.tfvars"

# Parse command line options
while getopts ":e:" opt; do
  case ${opt} in
    e)
      file_location="$OPTARG"
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

# Check if file_location exists and is a file
if [ ! -f "$file_location" ]
then
    echo "$file_location does not exist or is not a file. Exiting."
    exit 1
fi

# Extract environment from the provided file
environment=$(grep "^stage" "$file_location" | awk -F "=" '{print $2}' | tr -d ' "')

# Check if environment was extracted successfully
if [ -z "$environment" ]
then
    echo "No stage environment found in $file_location. Exiting."
    exit 1
fi

# Define the source and target file paths
source_file="./.backends/$environment.tf.txt"
target_file="./backend.tf"

# Check if source file exists
if [ ! -f "$source_file" ]
then
    echo "Source file $source_file not found. Please check the environment input."
    exit 1
fi

# Perform the copy operation
cp "$source_file" "$target_file"
echo "Environment sync completed. Content of $source_file copied to $target_file."
