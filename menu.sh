#!/bin/bash

# Opciones del menú
declare -a items=(
    "Parar docker"
    "Limpiar colima"
    "Levantar lab de cero"
    "Levantar lab (último estado)"
    "Iniciar contenedor"
    "Parar contenedor"
    "Entrar al contenedor"
    "Salir"
)

declare -a commands=(
    "scripts/cleanup-htb.sh"          # Parar docker
    "scripts/cleancolima.sh"         # Limpiar colima
    "scripts/uplab.sh --build"       # Levantar lab de cero
    "scripts/uplab.sh --rebuild"     # Levantar lab último estado
    "docker container start htb-vnc-lab" # Iniciar contenedor
    "docker container stop htb-vnc-lab" # Parar contenedor
    "scripts/joincontainer.sh"       # Entrar al contenedor
)

# Función para mostrar el menú
show_menu() {
    echo "HTB MANAGER LAB"
    echo "================"
    for i in "${!items[@]}"; do
        echo "  $((i + 1)). ${items[$i]}"
    done
    echo ""
    echo "Selecciona una opción ingresando el número correspondiente:"
}

# Inicializa variables
selected=0

# Da permisos de ejecución a los scripts
chmod +x scripts/*.sh 2>/dev/null || echo "Advertencia: No se pudo dar permisos de ejecución a los scripts."

# Bucle principal del menú
while true; do
    clear
    echo "==============================="
    echo "       HTB Manager Lab         "
    echo "==============================="
    for i in "${!items[@]}"; do
        echo "$((i + 1))) ${items[$i]}"
    done
    echo "-------------------------------"
    read -p "Selecciona una opción: " option

    if [[ "$option" =~ ^[0-9]+$ ]] && ((option >= 1 && option <= ${#items[@]})); then
        if [[ $option -eq ${#items[@]} ]]; then
            echo "Saliendo..."
            break
        fi

        clear
        echo "Ejecutando: ${commands[$((option - 1))]}"
        if [[ "${commands[$((option - 1))]}" == *"joincontainer.sh"* ]]; then
            echo "Entrando al contenedor..."
            bash "${commands[$((option - 1))]}"
            echo "Has salido del contenedor. Presiona cualquier tecla para volver al menú."
            read -rsn1
        else
            eval "${commands[$((option - 1))]}"
            echo "Presiona cualquier tecla para volver al menú."
            read -rsn1
        fi
    else
        echo "Opción inválida. Intenta de nuevo."
        sleep 1
    fi

done

clear
echo "¡Hasta luego!"
