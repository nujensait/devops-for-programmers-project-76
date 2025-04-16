# setup_docker.sh

# Запустите playbook:
ansible-playbook -i inventory.ini install_docker.yml

# Для проверки работы Docker после выполнения playbook:
ansible all -u mvikonnikov -i inventory.ini -m command -a "docker --version"