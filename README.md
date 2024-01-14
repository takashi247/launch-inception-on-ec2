# Overview

A repository to launch a Wordpress website on Debian EC2 instance using docker-compose.

# Requirement

- AWS account
- Your own domain

# Setup

Before running the make file, below are the required preparation on a vanilla Debian environment.

### 1. Connect to Your EC2 Instance:

- Use an SSH client to connect to your EC2 instance. The command usually looks like:

```
ssh -i /path/to/your-key.pem debian@your-ec2-instance-ip
```

- Replace /path/to/your-key.pem with your private key file's path, and your-ec2-instance-ip with your EC2 instance's public IP address.

### 2. Install Prerequisites:

- Install packages to allow apt to use a repository over HTTPS:

```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
```

*(Under construction)*
