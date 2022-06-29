#!/bin/bash

# Original instructions from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
sudo apt-get --quiet --yes update
sudo apt-get --quiet install apt-transport-https gnupg

# Download and install Microsoft signing key
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

source /etc/os-release
#TODO warn if not Ubuntu

# Add the repository
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $VERSION_CODENAME main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get --quiet --yes update
sudo apt-get --quiet --yes install azure-cli

az version