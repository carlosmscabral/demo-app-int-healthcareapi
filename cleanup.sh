#!/bin/bash

### Cleanup

source ./env.sh

# Remove Observation and Encounter resources
curl -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Observation/$(cat ids.json | jq -r '.observation_id')"

curl -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Encounter/$(cat ids.json | jq -r '.encounter_id')"

rm request-encounter.json request-observation.json

### DELETE observation bundles

# # Ensure the input file exists
# if [[ ! -f observation-ids.txt ]]; then
#     echo "Error: File observations-ids.txt not found."
#     exit 1  # Exit with an error code
# fi

# Read the file line by line
while IFS= read -r line 
do  
    # Remove the /_history part of the URI
    uri=$(echo $line | sed 's/\/_history.*//' | tr -d '"')

    echo "Deleting observation: $uri"
    curl -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "${uri}"

done < observation-ids.txt 

rm observation-ids.txt

# Remove patient
curl -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Patient/$(cat ids.json | jq -r '.patient_id')"

rm ids.json