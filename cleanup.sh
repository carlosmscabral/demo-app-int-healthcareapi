#!/bin/bash
### Cleanup

curl -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Observation/$(cat ids.json | jq -r '.observation_id')"

curl -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Encounter/$(cat ids.json | jq -r '.encounter_id')"

curl -X DELETE \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://healthcare.googleapis.com/v1/${FHIR_STORE}/fhir/Patient/$(cat ids.json | jq -r '.patient_id')"

rm request-encounter.json request-observation.json ids.json