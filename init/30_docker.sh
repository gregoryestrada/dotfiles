[[ ! "$(type -P docker)" ]] && e_error "Docker needs to be installed." && return 1

e_header "Docker Mods"

e_success $(docker --version)

# docker user sans sudo
sudo usermod -aG docker $USER
if id -nG "$USER" | grep -qw "docker"; then
    e_success "User added to docker group"
else
    e_error "User could not be added to docker group"
fi

# docker on boot
sudo systemctl enable docker
if (systemctl is-active docker) == "active"; then
    e_success "Docker is running"
else
    e_error "Docker is not running"

e_header "docker-machine"
# install docker-machine
base=https://github.com/docker/machine/releases/download/v0.14.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
e_success $(docker-machine version)

#bash completion
base=https://raw.githubusercontent.com/docker/machine/v0.14.0
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
  sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done

source /etc/bash_completion.d/docker-machine-prompt.bash
# .bashrc addon
#PS1='[\u@\h \W$(__docker_machine_ps1)]\$ '

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#   bash completion
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.21.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
