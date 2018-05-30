[[ ! "$(type -P docker)" ]] && e_error "Docker needs to be installed." && return 1

# docker user sans sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# docker on boot
sudo systemctl enable docker

# install docker-machine
base=https://github.com/docker/machine/releases/download/v0.14.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
docker-machine version

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
