#!/bin/bash

CONTAINER_NAME="htb-vnc-lab"   # <-- Cambia aquí si usas otro nombre
IMAGE_NAME="htb-vnc-lab:latest"  # O ajusta el tag si usas otro

echo "[+] Deteniendo contenedor $CONTAINER_NAME..."
docker stop "$CONTAINER_NAME" 2>/dev/null

echo "[+] Borrando contenedor $CONTAINER_NAME..."
docker rm "$CONTAINER_NAME" 2>/dev/null

echo "[+] Borrando imagen $IMAGE_NAME..."
docker rmi "$IMAGE_NAME" 2>/dev/null

echo "[+] ¡Todo limpio! 🚀"