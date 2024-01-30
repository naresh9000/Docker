#!/bin/bash

# Define the container image to scan
IMAGE_NAME="alpine:latest"
# for example, IMAGE_NAME="alpine:latest",mysql:latest
# Run Trivy to scan the container image
trivy image $IMAGE_NAME

# Check the exit code of Trivy
TRIVY_EXIT_CODE=$?

# Handle Trivy's exit code
case $TRIVY_EXIT_CODE in
    0)
        echo "Trivy scan completed successfully. No vulnerabilities found."
        ;;
    1)
        echo "Trivy encountered errors during the scan."
        ;;
    2)
        echo "Trivy found vulnerabilities in the scanned image."
        ;;
    3)
        echo "Trivy encountered fatal errors during the scan."
        ;;
    *)
        echo "Unknown error occurred while running Trivy."
        ;;
esac

# Exit with the same code as Trivy
exit $TRIVY_EXIT_CODE
