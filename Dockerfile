FROM ubuntu:21.04
LABEL Maintainer = "Kalen Arndt <me@kalen.sh>"
ENV DEBIAN_FRONTEND=noninteractive
ARG USER=kalen
ARG SSHKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWz+0sRMjwuEKQ57cMZesVavDXzUY7MBeeoTwj8lScbI6DeWkBgDShYYamXloLP8egx2FSHmPpp0EakhEjq2Bhlx0h+x69SJB29Gw8w3NdMCmXMOR3fxaqjafau60elHYCBWmhBkkauSUptwZaHX10kQcWjJewtAIpcp81IzVdzg7/AbY4xcteDo9fa9BrHWhh0yAl+KTduHBbMFg2mCxIIRwqqdYNibIGV70+tHNyBi6H4qYJ+Ph2t7PIWKWGBsBHPWmyvzrN+NKy33GBDwiXaRxq7nHRn5/BFMStPu1QDN9aKS1e06ebIgrt/cuhwrjHMWEI8sBs9EzOcBuPBS5Vs9yNroJodhuU870XE5ubn3smZwjTObkhhfZKMLr6DB7J7ZEuMRMbTGaeFk7N/fTEavhF884xeHX8p3dOOanwV146spqJOph4grcGJ45gRJn/DlyHoQRrz/qgSy0xwDV+APvzo3wmy2Twlr4qPsbto797AJRhNcphIRrxyVbu/J8="

# Install Packages
RUN apt-get update && apt-get -y install --no-install-recommends \
  wget \
  apt-utils \
  gpg-agent \
  locales-all \
  locales \
  curl \
  ca-certificates \
  openssl \
  git \
  sudo \
  httpie \
  less \
  vim \
  openssh-server \
  software-properties-common \
  iputils-ping \
  iputils-tracepath \
  zsh \
  && curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
  && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  consul \
  terraform \
  consul-terraform-sync \
  vault \
  packer \
  && apt-get remove -y apt-utils software-properties-common gpg-agent \
  && apt-get clean -y \
  && apt-get autoremove -y \
  && rm -rf /tmp/* /var/tmp/* \
  && rm -rf /var/lib/apt/lists/*


# Remote SSH fun
RUN mkdir /var/run/sshd \
  && useradd -ms /bin/zsh $USER \
  && usermod -a -G sudo $USER \
  && bash -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers" \
  && mkdir -p /home/$USER/.ssh \
  && mkdir -p /home/$USER/code \
  && touch /home/$USER/.ssh/authorized_keys \
  && echo $SSHKEY > /home/$USER/.ssh/authorized_keys \
  && chown -R $USER /home/$USER \
  && sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config

COPY dotfiles/.zshrc /home/$USER/.zshrc

# Install Oh-My-ZSH
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -p git -p ssh-agent -p 'history-substring-search' \
    -t robbyrussell \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && cp -r /root/.oh-my-zsh /home/$USER/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]