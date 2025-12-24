# Dockerización rápida de Parrot para Hack The Box

Este proyecto nació porque me daba **pajita** levantar una máquina virtual pesada cada vez que quería hacer una caja en Hack The Box 😅.  
Así que armé este entorno liviano y rápido en Docker, con soporte para VPN de HTB y montaje de workspace directo. Lo uso para resolver labs, entrenar, y tener todo limpio y automatizado.

## ¿Qué hace?

- Levanta un contenedor con Parrot Security Core
- Conecta automáticamente a tu VPN `.ovpn` de Hack The Box
- Monta tu carpeta `workspace` para guardar tus scripts, notas o herramientas
- Todo con un solo comando: `./uplab.sh`

## Requisitos

- Docker y Docker Compose instalados
- Archivo `.ovpn` de Hack The Box
- Permisos de ejecución para `uplab.sh`

## Estructura esperada

```
└── 📁HackTheBox
    └── 📁config
        ├── tmux.conf
        ├── vimrc
    └── 📁docker
        ├── docker-compose.yml
        ├── Dockerfile
    └── 📁vpn
        ├── tu_vpn.ovpn
    └── 📁workspace
        └── Aquí va tu magia.
    ├── .gitignore
    ├── README.md
    └── uplab.sh
```

## Permisos del script

```bash
chmod +x uplab.sh
```
## Si inicias por primera vez la maquina

```bash
./uplab.sh --build
```
## Si quieres recompilar lo que ya tienes

```bash
./uplab.sh --rebuild
```

## Para ver las opciones del comando

```bash
./uplab.sh --help
```

## Proximas mejoras.

- Automatizar creacion de los directorios.
- Dejarlo mas customizable para laboratorios locales.

desarrollado por vmonsalve.