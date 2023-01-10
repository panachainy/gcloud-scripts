#!/bin/bash

PROJECT=default-project

# check if --run is provided as an argument
if [ "$1" == "run" ]; then
    RUN_MODE=true
    PROJECT="$2"
    shift
else
    RUN_MODE=false
    PROJECT="$1"
fi

# Read the .env file
while IFS='=' read -r key value; do
    # Remove leading and trailing whitespace from the key and value
    key="${key#"${key%%[![:space:]]*}"}"
    value="${value#"${value%%[![:space:]]*}"}"

    if $RUN_MODE; then
      # Create the secret in Google Cloud Secrets Manager
      printf "%s" "$value" | gcloud secrets create "$key" --data-file=- --replication-policy="automatic" --labels="project=$PROJECT"
    else
      echo "printf %s $value | gcloud secrets create $key --data-file=- --replication-policy=automatic --labels=project=$PROJECT"
    fi
    # Create the secret in Google Cloud Secrets Manager
done < .env
