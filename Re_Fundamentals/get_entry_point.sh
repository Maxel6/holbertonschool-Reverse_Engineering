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
magic_number=$(hexdump -n 4 -e '4/1 "%02x " "\n"' "$file_name")
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2, $3}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3}')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Inclure le fichier messages.sh
source messages.sh

# Afficher les informations formatées
display_elf_header_info

