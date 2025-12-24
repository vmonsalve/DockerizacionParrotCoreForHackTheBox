FROM parrotsec/core

# Instalar herramientas
RUN apt update && apt install -y \
  tmux \
  nmap ffuf wfuzz responder impacket-scripts \
  seclists \
  curl wget git \
  python3 python3-pip \
  dnsutils iputils-ping netcat-traditional \
  metasploit-framework \
  sudo \
  openvpn \
  vim \
  && apt clean

# Variables de usuario
ARG NEWUSER
ARG NEWPASS

# Crear usuario no root
RUN useradd -m -s /bin/bash $NEWUSER && \
    echo "$NEWUSER:$NEWPASS" | chpasswd && \
    usermod -aG sudo $NEWUSER
    
# Permitir a ese usuario ejecutar openvpn sin pedir contraseña
RUN echo "$NEWUSER ALL=(ALL) NOPASSWD: /usr/sbin/openvpn" > /etc/sudoers.d/openvpn && \
    chmod 0440 /etc/sudoers.d/openvpn

# Copiar vimrc al sistema
COPY ../config/vimrc /etc/vim/vimrc

# Copiar .tmux.conf al home del nuevo usuario
COPY ../config/tmux.conf /home/${NEWUSER}/.tmux.conf
RUN chown ${NEWUSER}:${NEWUSER} /home/${NEWUSER}/.tmux.conf

# Establecer usuario por defecto
USER ${NEWUSER}
WORKDIR /home/${NEWUSER}