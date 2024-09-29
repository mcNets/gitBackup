#!/bin/bash

# Clear terminal
clear

# Script version
version="1.0.0"
echo -e "\e[32mgitBackup Ver. $version\e[0m"

# Check there is a appsettings.json file
if [ ! -f "appsettings.json" ]; then
    echo -e "\e[31mappsettings.json no encontrado\e[0m"
    echo "Sigue las instrucciones en README.md para crear el archivo"
    echo "https://github.com/mcNets/gitBackup"
    exit 1
fi

# Read appsettings.json file
appsettings=$(cat appsettings.json)
backupFolder=$(echo "$appsettings" | jq -r '.AppSettings.BackupFolder')
repositories=$(echo "$appsettings" | jq -c '.Repositories[]')

echo "BackupFolder: $backupFolder"

# Backup folder validation
echo "Verificando la carpeta de respaldo: $backupFolder"
if [ ! -d "$backupFolder" ]; then
    mkdir -p "$backupFolder"
    if [ ! -d "$backupFolder" ]; then
        echo -e "\e[31mNo se pudo crear la carpeta de respaldo: $backupFolder\e[0m"
        exit 1
    fi
fi

# Copy repositories
for repository in $repositories; do
    name=$(echo "$repository" | jq -r '.Name')
    path=$(echo "$repository" | jq -r '.Path')
    url=$(echo "$repository" | jq -r '.URL')

    echo "Realizando copia de seguridad del repositorio: $name"

    backupPath="$backupFolder/$path"
    if [ ! -d "$backupPath" ]; then
        git clone "$url" "$backupPath"
    else
        git -C "$backupPath" pull
    fi

    if [ $? -eq 0 ]; then
        echo -e "\e[32mCopia de seguridad del repositorio $name completada con éxito\e[0m"
    else
        echo -e "\e[31mError al realizar la copia de seguridad del repositorio $name\e[0m"
    fi
done
