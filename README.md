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

### Additional setups

- To setup docker on both VM-s & check setup result, run:
```
./setup_docker.sh
```

----
