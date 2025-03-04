#!/bin/bash

# Vérifier si un fichier est passé en argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

file_name="$1"

# Vérifier si le fichier existe
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' not found!"
    exit 1
fi

# Vérifier si le fichier est un ELF
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not an ELF file!"
    exit 1
fi

# Extraire les informations de l'en-tête ELF

# Magic Number (16 octets)
magic_number=$(xxd -l 16 -p "$file_name" | tr -d '\n' | sed 's/\(..\)/\1 /g')

# Class (32-bit ou 64-bit)
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')

# Byte Order (Endianness)
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3}')

# Entry Point Address
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Inclure le fichier messages.sh
source messages.sh

# Afficher les informations formatées
display_elf_header_info
