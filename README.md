# Laboratorio Docker hackthebox

Este proyecto nacio de la pajita que me daba levantar la maquina de parrot cada vez que queria hacer una maquina en hackthebox.

## Dependencias

- Docker.
- vpn hacthebox.

## Preparación previa.

Debemos crear los direcotrios workspace y vpn

```bash
mkdir workspace vpn
```
una vez creados si tienes tu vpn hackthebox debes moverla a tu directorio vpn.

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