FROM ubuntu:21.04
LABEL Maintainer = "Kalen Arndt <me@kalen.sh>"
ENV DEBIAN_FRONTEND=noninteractive
ARG USER=kalen
ARG SSHKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWz+0sRMjwuEKQ57cMZesVavDXzUY7MBeeoTwj8lScbI6DeWkBgDShYYamXloLP8egx2FSHmPpp0EakhEjq2Bhlx0h+x69SJB29Gw8w3NdMCmXMOR3fxaqjafau60elHYCBWmhBkkauSUptwZaHX10kQcWjJewtAIpcp81IzVdzg7/AbY4xcteDo9fa9BrHWhh0yAl+KTduHBbMFg2mCxIIRwqqdYNibIGV70+tHNyBi6H4qYJ+Ph2t7PIWKWGBsBHPWmyvzrN+NKy33GBDwiXaRxq7nHRn5/BFMStPu1QDN9aKS1e06ebIgrt/cuhwrjHMWEI8sBs9EzOcBuPBS5Vs9yNroJodhuU870XE5ubn3smZwjTObkhhfZKMLr6DB7J7ZEuMRMbTGaeFk7N/fTEavhF884xeHX8p3dOOanwV146spqJOph4grcGJ45gRJn/DlyHoQRrz/qgSy0xwDV+APvzo3wmy2Twlr4qPsbto797AJRhNcphIRrxyVbu/J8="

# Install Packages
RUN  apt-get -y update --allow-unauthenticated && \
  apt-get -y dist-upgrade && \
  apt-get -y --force-yes install \
  apt-utils \
  curl \
  htop \
  ca-certificates \
  openssl \
  git \
  sudo \
  vim \
  unzip \
  httpie \
  supervisor \
  openssh-server \
  sshpass \
  software-properties-common \
  rsync \
  iputils-arping \
  iputils-clockdiff \
  iputils-ping \
  iputils-tracepath \
  zsh \
  fonts-powerline \
  zsh-syntax-highlighting

# Remote SSH fun
RUN mkdir /var/run/sshd
RUN useradd -ms /bin/zsh $USER
RUN usermod -a -G sudo $USER
RUN bash -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers"
RUN mkdir -p /home/$USER/.ssh
RUN mkdir -p /home/$USER/code
COPY dotfiles/.zshrc /home/$USER/.zshrc
RUN touch /home/$USER/.ssh/authorized_keys
RUN echo $SSHKEY > /home/$USER/.ssh/authorized_keys
RUN chown -R $USER /home/$USER
RUN sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config

# HashiCorp Repos
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install HashiCorp tools
RUN apt-get -y update && \
  apt-get install -y terraform vault consul consul-terraform-sync packer


# Install Oh-My-ZSH
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -p git -p ssh-agent -p 'history-substring-search' \
    -t robbyrussell \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

# Copy Oh-My-ZSH to remote ssh user
RUN cp -r /root/.oh-my-zsh /home/$USER/

# Cleanup
RUN apt-get clean && apt-get autoremove
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]