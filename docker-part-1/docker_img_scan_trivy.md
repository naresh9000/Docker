 Trivy scans the images...
 Trivy regularly updates its vulnerability database to ensure it includes the latest security advisories and patches.


=>apt-get install wget apt-transport-https gnupg lsb-release
=>wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
=>echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
=>apt-get update
=>apt-get install trivy


This script downloads Trivy binary based on your OS and architecture and isntall trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.48.3

