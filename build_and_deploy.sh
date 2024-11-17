#!/bin/bash

# Enable debugging mode if needed
# set -x

# Entire pipeline/ script fails if any command within the pipeline/ script fails
set -o pipefail

DOCKER_HUB_REPOSITORY="hala0ner"
DOCKER_IMAGE_NAME="yarowa-demo"
DOCKER_IMAGE_TAG="1.0.1"

# Function to check if Docker is installed
dependency_check() {
    if ! command -v docker &> /dev/null; then
        echo "Error: docker command not found"
        echo "Install Docker on the local machine and re-execute the script!"
        exit 1
    fi

    if ! command -v helmfile &> /dev/null; then
        echo "Error: helmfile command not found"
        echo "Install helmfile on the local machine and re-execute the script!"
        exit 1
    fi
}

# Function to build the Docker image
build() {
    echo "Building Docker image ${DOCKER_HUB_REPOSITORY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ..."
    docker build -t ${DOCKER_HUB_REPOSITORY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .
    if [ $? -ne 0 ]; then
        echo "Docker build failed."
        exit 1
    fi
    echo "Docker image successfully built: ${DOCKER_HUB_REPOSITORY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
}

# Function to push the Docker image
push() {
    echo "Pushing the Docker image to ${DOCKER_HUB_REPOSITORY} ..."
    docker push ${DOCKER_HUB_REPOSITORY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
    if [ $? -ne 0 ]; then
        echo "Docker push failed."
        exit 1
    fi
    echo "Docker image was successfully pushed: ${DOCKER_HUB_REPOSITORY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
}

# Function to deploy Helm chart in to Kubernetes cluster
helmfile_deploy() {
    echo "Installing required dependencies..."
    echo "Syncing the Kubernetes cluster state to the desired one..."
    cd helmfile.d/
    helmfile init && helmfile apply
}

test_connection() {
    URL="casestudy.local.yarowa.io"

    echo "Waiting for the application to start up..."
    sleep 5

    # Send the request and capture the status code
    STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}" "${URL}")

    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "OK: Endpoint returned HTTP 200 response status code"
    else
        echo "Error: Endpoint returned status code $STATUS_CODE"
    fi

}

# Main function to call other functions
main() {
    dependency_check
    #build
    #push
    helmfile_deploy
    test_connection
}

# Call the main function
main
