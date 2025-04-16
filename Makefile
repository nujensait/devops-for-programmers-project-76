.PHONY: init deploy-docker configure-lb setup-db verify

init:
	ansible-galaxy install -r requirements.yml

deploy-docker:
	ansible-playbook -i inventory.ini playbook.yml --tags docker

configure-lb:
	ansible-playbook -i inventory.ini playbook.yml --tags loadbalancer

setup-db:
	ansible-playbook -i inventory.ini playbook.yml --tags database

verify:
	ansible webservers -i inventory.ini -m command -a "docker --version"
	ansible database -i inventory.ini -m command -a "sudo systemctl status postgresql"