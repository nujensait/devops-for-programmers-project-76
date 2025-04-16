# Запустите playbook:
ansible-playbook -i hosts.ini install_docker.yml

# Для проверки работы Docker после выполнения playbook:
ansible all -u mvikonnikov -i hosts.ini -m command -a "docker --version"