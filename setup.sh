#!/bin/bash

# asssumes pre-created FHIR Store, used the Console for creation

source ./env.sh

# Create Patient
patient_id=$(curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json" \
    -d @request-patient.json \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Patient" | jq -r '.id')

echo "Patient created with ID: ${patient_id}"

## Creating a bundle of observations

echo "Creating a bundle of observations"
sed "s/PATIENT_ID/${patient_id}/g" request-observation-bundle-template.json > request-observation-bundle.json

curl -X POST \
    -H "Content-Type: application/fhir+json; charset=utf-8" \
    -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
    --data @request-observation-bundle.json \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir" | jq '.entry[].response.location' > observation-ids.txt

### Creating an encounter

sed "s/PATIENT_ID/${patient_id}/g" request-encounter-template.json > request-encounter.json

encounter_id=$(curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json" \
    -d @request-encounter.json \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Encounter" | jq -r '.id')

echo "Encounter created with ID: ${encounter_id}"

### Creating an observation
sed "s/PATIENT_ID/${patient_id}/g;s/ENCOUNTER_ID/${encounter_id}/g" request-observation-template.json > request-observation.json

observation_id=$(curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json" \
    -d @request-observation.json \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Observation" | jq -r '.id')

echo "Observation created with ID: ${observation_id}"

echo "{\"patient_id\": \"${patient_id}\",\"encounter_id\": \"${encounter_id}\",\"observation_id\": \"${observation_id}\"}" > ids.json

