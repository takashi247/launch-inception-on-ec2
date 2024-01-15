## Overview

A repository to launch a Wordpress website on Debian EC2 instance using docker-compose.

## Requirement

- AWS account
- EC2 instance (Debian 12 (HVM), SSD Volume Type, x86, t2.micro)
- Your own domain

## Setup

Before running the make file, below are the required preparation on a vanilla Debian environment.

### 1. Connect to Your EC2 Instance:

- Use an SSH client to connect to your EC2 instance. The command usually looks like:

```
ssh -i /path/to/your-key.pem debian@your-ec2-instance-ip
```

- Replace /path/to/your-key.pem with your private key file's path, and your-ec2-instance-ip with your EC2 instance's public IP address.

### 2. Install Prerequisites:

- Set up Docker's `apt` repository (Ref: https://docs.docker.com/engine/install/debian/).

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

- Then, install the Docker packages (including the Compose plugin).

```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### _(Under construction)_
