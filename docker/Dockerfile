FROM parrotsec/core

# Instalar herramientas
RUN apt update && apt install -y \
  tmux \
  nmap ffuf wfuzz responder impacket-scripts \
  curl wget git \
  python3 python3-pip \
  dnsutils iputils-ping netcat-traditional \
  metasploit-framework \
  sudo \
  openvpn \
  vim \
  fluxbox \
  firefox-esr \
  tightvncserver \
  && apt clean && rm -rf /var/lib/apt/lists/*

# Variables de usuario
ARG NEWUSER
ARG NEWPASS


#copiar configuracion de fluxbox
COPY ../config/menu /etc/X11/fluxbox/fluxbox-menu
# Copiar vimrc al sistema
COPY ../config/vimrc /etc/vim/vimrc

# Crear nuevo usuario
RUN useradd -m -s /bin/bash $NEWUSER && \
    echo "$NEWUSER:$NEWPASS" | chpasswd && \
    usermod -aG sudo $NEWUSER 

# Configurar VNC para el nuevo usuario
RUN mkdir -p /home/${NEWUSER}/.vnc && \
    chown -R ${NEWUSER}:${NEWUSER} /home/${NEWUSER}/.vnc && \
    su - ${NEWUSER} -c "sh -c 'echo \"${NEWPASS}\" | vncpasswd -f > ~/.vnc/passwd'" && \
    chmod 600 /home/${NEWUSER}/.vnc/passwd

# Permitir a ese usuario ejecutar openvpn sin pedir contraseña
RUN echo "$NEWUSER ALL=(ALL) NOPASSWD: /usr/sbin/openvpn" > /etc/sudoers.d/openvpn && \
    chmod 0440 /etc/sudoers.d/openvpn


# Copiar .tmux.conf al home del nuevo usuario
COPY ../config/tmux.conf /home/${NEWUSER}/.tmux.conf
RUN chown ${NEWUSER}:${NEWUSER} /home/${NEWUSER}/.tmux.conf


RUN cat <<'EOF' > /usr/local/bin/start-vnc.sh
#!/bin/bash
export USER=$(whoami)
vncserver :1 -geometry 1280x800 -depth 24 -name "parrot-vnc"
sleep infinity
EOF
RUN chmod +x /usr/local/bin/start-vnc.sh

# Establecer usuario por defecto
USER ${NEWUSER}
CMD ["/usr/local/bin/start-vnc.sh"]