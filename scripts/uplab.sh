#!/bin/bash

show_help() {
  echo "Uso: $0 [opciones]"
  echo ""
  echo "Opciones:"
  echo "  --help     Muestra esta ayuda"
  echo "  --build    Construye la imagen Docker con el usuario y contraseña proporcionados desde cero"
  echo "  --rebuild  Fuerza la reconstrucción completa del contenedor (baja, build y up)"
  exit 0
}

if [ $# -eq 0 ]; then
  show_help
fi

set -e

PROJECT_DIR="$(dirname "$(realpath "$0")")/.."

cd "$PROJECT_DIR"

CONTAINER_NAME="htb-vnc-lab"
SESSION="htb"

# Validar y crear directorios necesarios
[ ! -d "$PROJECT_DIR/vpn" ] && mkdir -p "$PROJECT_DIR/vpn" && echo "[+] Carpeta 'vpn/' creada."
[ ! -d "$PROJECT_DIR/workspace" ] && mkdir -p "$PROJECT_DIR/workspace" && echo "[+] Carpeta 'workspace/' creada."

# Verificar si Docker está instalado
command -v docker >/dev/null 2>&1 || { echo >&2 "Docker no está instalado. Abortando."; exit 1; }

# Pedir usuario y contraseña
read -p "Ingresa el nombre de usuario para el contenedor: " NEWUSER
read -p "Ingresa la contraseña (deja vacío para usar el mismo nombre): " NEWPASS

NEWPASS="${NEWPASS:-$NEWUSER}"

export NEWUSER
export NEWPASS
export CONTAINER_NAME

# --rebuild = bajar + build + up
if [[ "$1" == "--rebuild" ]]; then
  echo "[+] Limpiando contenedor anterior..."
  docker compose -f "$PROJECT_DIR/docker/docker-compose.yml" down

  echo "[+] Rebuild forzado..."
  docker compose -f "$PROJECT_DIR/docker/docker-compose.yml" build --no-cache \
    --build-arg NEWUSER="$NEWUSER" \
    --build-arg NEWPASS="$NEWPASS"
fi

# Si se pasa --build
if [[ "$1" == "--build" ]]; then
  echo "[+] Rebuild de imagen con usuario $NEWUSER..."
  docker build --no-cache \
    --build-arg NEWUSER="$NEWUSER" \
    --build-arg NEWPASS="$NEWPASS" \
    -f "$PROJECT_DIR/docker/Dockerfile" \
    -t "$CONTAINER_NAME" .
fi

echo "[+] Levantando contenedor..."

docker compose -f "$PROJECT_DIR/docker/docker-compose.yml" up -d

echo "[+] Entrando al contenedor..."

docker exec -it "$CONTAINER_NAME" bash -lc "
  tmux has-session -t $SESSION 2>/dev/null || (
    tmux new-session -d -s $SESSION
    tmux rename-window -t $SESSION:0 'vpn'
    tmux send-keys -t $SESSION:0 'sudo openvpn --config ~/vpn/starting_point_H4rdC0r3Dev.ovpn' C-m

    tmux split-window -h -t $SESSION
    tmux rename-window -t $SESSION:1 'work'
  )

  tmux attach -t $SESSION
"