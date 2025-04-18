# Table of Contents
1. [About this project](#about-this-project)
2. [Hexlet tests status](#hexlet-tests-and-linter-status)
3. [Requirements](#requirements)
4. [Configuration](#configuration)
5. [Installation](#installation)
6. [Infrastructure Deployment](#infrastructure-deployment)
7. [Deployed Application](#deployed-application)
8. [Deployment Commands](#deployment-commands)
9. [Database Setup](#database-setup)
10. [Manual Verification](#manual-verification)
11. [Monitoring Setup](#monitoring-setup)
12. [Contacts](#contacts)

-----

## About this project
- Hexlet's course: ["DevOps for Programmers"](https://lite.al/VpBen)
- Project #2: Docker images deployment with Ansible

----

## Hexlet tests and linter status:
[![Actions Status](https://github.com/nujensait/devops-for-programmers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/nujensait/devops-for-programmers-project-76/actions)

----

## Requirements
- Ansible ≥ 2.12
- Python ≥ 3.8

----

## Configuration
- Server IPs are defined in ``inventory.ini``
- Variables are set in ``group_vars/webservers.yml``

----

## Installation
1. Install dependencies:
```bash
make install-deps
```
2. Deploy to servers:
```bash
make deploy
```

----

## Infrastructure Deployment

1. Initialize environment:

```bash
make init
```
2. Deploy components separately:

```
# Docker on webservers
make deploy-docker

# Load Balancer
make configure-lb

# Database
make setup-db
```

3. Verify installation:

```
make verify
```

----

## Deployed Application
Access the live application: [https://webpinger.net](https://webpinger.net)

----

## Deployment Commands

1. First deployment:

```bash
make deploy-redmine
```

2. Setup HTTPS:

```bash
make setup-https
```

3. Verify:

```bash
make verify-app
```

-----

## Database Setup

1. Create vault password file:
```bash
echo "your_password" > vault-pass.txt
chmod 600 vault-pass.txt
```

2. Edit encrypted variables:
```bash
make edit-vault
```

3. Deploy with database:
```bash
make deploy-with-db
```

-----

## Manual Verification

```bash
# Check containers
ansible webservers -i inventory.ini -m command -a "docker ps"

# Check nginx
ansible loadbalancer -i inventory.ini -m command -a "systemctl status nginx"
```

----

## Monitoring Setup

1. Set up DataDog:

```bash
make setup-monitoring
```

2. Verify agent status:

```bash
make verify-monitoring
```

----

## Contacts

- Author: Mikhail Ikonnikov <mishaikon@gmail.com>

----
