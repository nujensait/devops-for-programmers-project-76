.PHONY: init install-deps deploy deploy-docker configure-lb setup-db deploy-redmine setup-https verify clean

## Initialize environment
init:
	ansible-galaxy install -r requirements.yml

## Install dependencies (alias for init)
install-deps: init

## Full deployment pipeline
deploy: init deploy-docker configure-lb setup-db deploy-redmine setup-https

## Docker setup
deploy-docker:
	ansible-playbook -i inventory.ini playbook.yml --tags docker

## Load Balancer configuration
configure-lb:
	ansible-playbook -i inventory.ini playbook.yml --tags loadbalancer

## Database setup
setup-db:
	ansible-playbook -i inventory.ini playbook.yml --tags database

## Redmine application deployment
deploy-redmine:
	ansible-playbook -i inventory.ini playbook.yml --tags deploy

## HTTPS setup
setup-https:
	ansible-playbook -i inventory.ini playbook.yml --tags loadbalancer

## Verification commands
verify:
	@echo "=== Checking Docker ==="
	ansible webservers -i inventory.ini -m command -a "docker --version"
	@echo "\n=== Checking DB ==="
	ansible database -i inventory.ini -m command -a "sudo systemctl status postgresql"
	@echo "\n=== Checking Redmine ==="
	ansible webservers -i inventory.ini -m command -a "docker ps -f name=redmine --format '{{.Status}}'"
	@echo "\n=== Checking HTTPS ==="
	curl -sI https://webpinger.net | grep HTTP

## Cleanup (optional)
clean:
	ansible webservers -i inventory.ini -m command -a "docker stop redmine && docker rm redmine"

## Check playbook (install validator 1st):
check-playbook-setup:
	sudo apt install ansible-lint

## Check playbook:
check-playbook:
	pip install -r requirements.txt
	ansible-galaxy install -r requirements.yml --force
	ANSIBLE_COLLECTIONS_PATH=~/.ansible/collections ansible-lint playbook.yml -v
	# ansible-lint playbook.yml
