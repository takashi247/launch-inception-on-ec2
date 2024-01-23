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
sudo apt-get -y install ca-certificates curl gnupg
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
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

- Update permission for `/var/run/docker.sock`.

```
sudo chmod 666 /var/run/docker.sock
```

- Finally, install make command as well

```
sudo apt-get update
sudo apt-get -y install make
```

## Environment variables

To properly run the make command, you need to create `.env` file and place it in `/srcs` directory.

Below is the list of environment variables you need to specify in the `.env` file.

### Nginx parameters

| Variable      | Description                                                              |
| ------------- | ------------------------------------------------------------------------ |
| DOMAIN_NAME   | Your domain to access to your website.                                   |
| CERT_PATH     | A path to the SSL certificate (i.e., `.crt` file).                       |
| CERT_KEY      | A path to the SSL key (`.key` file).                                     |
| CERTBOT_EMAIL | E-mail address to be registered when installing certificate via Certbot. |

### MySQL parameters

| Variable            | Description                          |
| ------------------- | ------------------------------------ |
| MYSQL_USER          | MariaDB user name.                   |
| MYSQL_PASSWORD      | MariaDB user password.               |
| MYSQL_ROOT_PASSWORD | MariaDB root password.               |
| MYSQL_DATABASE      | Database name for Wordpress website. |

### Wordpress parameters

| Variable        | Description                              |
| --------------- | ---------------------------------------- |
| TITLE           | The title of your Wordpress website.     |
| ADMIN_USER      | Wordpress admin user name.               |
| ADMIN_PASSWORD  | Wordpress admin user password.           |
| ADMIN_EMAIL     | email address for Wordpress admin user.  |
| EDITOR_LOGIN    | Wordpress editor user name.              |
| EDITOR_PASSWORD | Wordpress editor user password.          |
| EDOTOR_EMAIL    | email address for Wordpress editor user. |

### Image names

| Variable           | Description                             |
| ------------------ | --------------------------------------- |
| IMG_NAME_NGINX     | Name of the Docker image for Nginx.     |
| IMG_NAME_WORDPRESS | Name of the Docker image for WordPress. |
| IMG_NAME_MARIADB   | Name of the Docker image for MariaDB.   |
| IMG_NAME_ADMINER   | Name of the Docker image for Adminer.   |
| IMG_NAME_REDIS     | Name of the Docker image for Redis.     |
| IMG_NAME_GRAFANA   | Name of the Docker image for Grafana.   |

### Container names

| Variable            | Description                                 |
| ------------------- | ------------------------------------------- |
| CONT_NAME_NGINX     | Name of the Docker container for Nginx.     |
| CONT_NAME_WORDPRESS | Name of the Docker container for WordPress. |
| CONT_NAME_MARIADB   | Name of the Docker container for MariaDB.   |
| CONT_NAME_ADMINER   | Name of the Docker container for Adminer.   |
| CONT_NAME_REDIS     | Name of the Docker container for Redis.     |
| CONT_NAME_GRAFANA   | Name of the Docker container for Grafana.   |

### Valume names

| Variable                 | Description                             |
| ------------------------ | --------------------------------------- |
| VOLUME_NAME_WP           | Name of the volume for WordPress files. |
| VOLUME_NAME_DB           | Name of the volume for the database.    |
| VOLUME_NAME_REDIS_BACKUP | Name of the volume for Redis backups.   |

### Port numbers

| Variable             | Description                              |
| -------------------- | ---------------------------------------- |
| PORT_NUM_NGINX_HTTP  | Port number assigned to Nginx for http.  |
| PORT_NUM_NGINX_HTTPS | Port number assigned to Nginx for https. |
| PORT_NUM_WORDPRESS   | Port number assigned to WordPress.       |
| PORT_NUM_MARIADB     | Port number assigned to MariaDB.         |
| PORT_NUM_ADMINER     | Port number assigned to Adminer.         |
| PORT_NUM_REDIS       | Port number assigned to Redis.           |
| PORT_NUM_GRAFANA     | Port number assigned to Grafana.         |

### Directory paths in host machine

| Variable               | Description                                        |
| ---------------------- | -------------------------------------------------- |
| HOST_PATH_DATA         | Path to the data directory on the host machine.    |
| HOST_PATH_WP           | Path to the WordPress files directory on the host. |
| HOST_PATH_DB           | Path to the database files directory on the host.  |
| HOST_PATH_REDIS_BACKUP | Path to the Redis backup directory on the host.    |

### Redis config

| Variable                   | Description                            |
| -------------------------- | -------------------------------------- |
| REDIS_SAVE_DURATION_IN_SEC | Duration in seconds for Redis to save. |
| REDIS_SAVE_MIN_REV         | Minimum revisions for Redis save.      |

### Grafana related config

| Variable                      | Description                              |
| ----------------------------- | ---------------------------------------- |
| GRAFANA_DATASOURCES_NAME      | Name of the datasource for Grafana.      |
| GF_SECURITY_ADMIN_USER        | Admin username for Grafana.              |
| GF_SECURITY_ADMIN_PASSWORD    | Admin password for Grafana.              |
| GF_SERVER_SERVE_FROM_SUB_PATH | Boolean to serve Grafana from a subpath. |
| GRAFANA_DASHBOARD_NAME        | Name of the dashboard in Grafana.        |
| TINI_VERSION                  | Version of Tini to be used.              |

## How to access services

### WordPress

- You can access to the Wordpress website via https://yourdomain/. (replace `yourdomain` with your actual domain name.)
- To access admin page, go https://yourdomain/wp-admin/.
- You can log into admin page by using either admin username/password or editor username/password.

### Adminer

- Adminer is a databased management tool. (see: https://www.adminer.org/)
- To access the Adminer page, go https://yourdomain/adminer/.
- To see the contents of MariaDB database, use the information below:
  - Server: Name of Wordpress DB (value of `CONT_NAME_MARIADB`)
  - Username: Username for MariaDB (value of `MYSQL_USER`)
  - Password: Password for MariaDB (value of `MYSQL_PASSWORD`)
  - Database: Name of Wordpress DB (value of `MYSQL_DATABASE`)

### Grafana

- Grafana is a popular open-source analytics and interactive visualization web application. (see: https://grafana.com/)
- To access the Grafana login page, go https://yourdomain/grafana/.
- Use Grafana admin account to log in.
  - Username: value of `GF_SECURITY_ADMIN_USER`
  - Password: value of `GF_SECURITY_ADMIN_PASSWORD`
- Click `Search` on the left panel and then go to `Wordpress statistics dashboard`.
