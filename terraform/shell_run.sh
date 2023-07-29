#!/bin/bash

# Initialize our own variables
input_script=""
input_command=""
declare -a validations

# Parse command line options
while getopts ":c:f:v:" opt; do
  case ${opt} in
    c)
      input_command="$OPTARG"
      ;;
    f)
      input_script="$OPTARG"
      ;;
    v)
      IFS=',' read -r -a validations <<< "$OPTARG"
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

# Run validations
for validation in "${validations[@]}"
do
   if [ -f "$validation" ]; then
       chmod +x "$validation"
       if bash "$validation"; then
           echo "Validation $validation passed."
       else
           echo "Validation $validation failed. Exiting."
           exit 1
       fi
   elif command -v "$validation" > /dev/null 2>&1; then
       if bash -c "$validation"; then
           echo "Validation $validation passed."
       else
           echo "Validation $validation failed. Exiting."
           exit 1
       fi
   else
       echo "Validation $validation is neither a script nor a valid command. Skipping."
   fi
done

# Check if script was provided
if [ ! -z "$input_script" ]
then
    if [ -f "$input_script" ]
    then
        echo "Running script $input_script"
        bash "$input_script"
    else
        echo "Script $input_script not found. Exiting."
        exit 1
    fi
fi

# Check if command was provided
if [ ! -z "$input_command" ]
then
    echo "Running command $input_command"
    bash -c "$input_command"
fi
