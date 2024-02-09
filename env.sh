#!/bin/bash

export PROJECT_ID="cabral-app-integration"
export REGION="southamerica-east1"
export FHIR_STORE="projects/cabral-app-integration/locations/southamerica-east1/datasets/cabral-dataset/fhirStores/cabral-fhir"

gcloud config set project ${PROJECT_ID}