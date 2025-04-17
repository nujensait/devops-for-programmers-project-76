.PHONY: init install-deps deploy deploy-docker configure-lb setup-db deploy-redmine setup-https verify clean

###########################################################
## LESSON 3: pre-deploy

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

###########################################################
## LESSON 4: Deploy

## Check playbook (install validator 1st):
check-playbook-setup:
	sudo apt install ansible-lint

## Check playbook:
check-playbook:
	pip install -r requirements.txt
	ansible-galaxy install -r requirements.yml --force
	ANSIBLE_COLLECTIONS_PATH=~/.ansible/collections ansible-lint playbook.yml -v
	# ansible-lint playbook.yml

#########################################
## LESSON 5: Deploy DB

VAULT_PASSWORD_FILE=vault-pass.txt

# Database operations
encrypt-vault:
	ansible-vault encrypt group_vars/webservers/vault.yml --vault-password-file $(VAULT_PASSWORD_FILE)

edit-vault:
	ansible-vault edit group_vars/webservers/vault.yml --vault-password-file $(VAULT_PASSWORD_FILE)

view-vault:
	ansible-vault view group_vars/webservers/vault.yml --vault-password-file $(VAULT_PASSWORD_FILE)

# Deployment with vault
deploy-with-db:
	ansible-playbook -i inventory.ini playbook.yml --tags deploy --vault-password-file $(VAULT_PASSWORD_FILE)

###########################################
## Lesson 7: DataDog monitoring

setup-monitoring:
	ansible-playbook -i inventory.ini playbook.yml --tags monitoring --vault-password-file $(VAULT_PASSWORD_FILE) --become

verify-monitoring:
	ansible webservers -i inventory.ini -m command -a "sudo systemctl status datadog-agent" --vault-password-file $(VAULT_PASSWORD_FILE) --become

clean-datadog-config:
	ansible webservers -i inventory.ini -m file -a "path=/etc/datadog-agent/conf.d/http_check.d/conf.yaml state=absent" --vault-password-file $(VAULT_PASSWORD_FILE) --become

###########################################
