#!/bin/bash

colima stop
echo "[+] Colima detenida."
colima delete -f
echo "[+] Colima eliminada."
colima start --disk 20 --cpu 8 --memory 8 --arch x86_64
echo "[+] Colima iniciada con 20GB de disco, 8CPU y 8GB de RAM."