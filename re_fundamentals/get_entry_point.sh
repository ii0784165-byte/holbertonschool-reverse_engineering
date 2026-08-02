#!/bin/bash

# Köməkçi mesaj funksiyasını bura daxil edirik
source ./messages.sh

# 1. Arqument yoxlanışı (Fayl adı yazılıbmı?)
if [ -z "$1" ]; then
    echo "Xəta: Zəhmət olmasa bir fayl adı daxil edin."
    echo "İstifadə qaydası: $0 <fayl_adı>"
    exit 1
fi

file_name="$1"

# 2. Faylın sistemdə mövcud olub-olmadığının yoxlanışı
if [ ! -f "$file_name" ]; then
    echo "Xəta: Fayl tapılmadı və ya mövcud deyil."
    exit 1
fi

# 3. Faylın düzgün ELF faylı olub-olmadığının yoxlanışı
if ! file "$file_name" | grep -q "ELF"; then
    echo "Xəta: Bu fayl etibarlı bir ELF faylı deyil."
    exit 1
fi

# 4. Məlumatların çıxarılması və sonundakı boşluqların tam təmizlənməsi
magic_number=$(readelf -h "$file_name" | grep "Magic:" | sed 's/^[ \t]*Magic:[ \t]*//;s/[ \t]*$//')
class=$(readelf -h "$file_name" | grep "Class:" | awk -F: '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk -F: '{print $2}' | awk -F, '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk -F: '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')

# 5. Nəticəni ekrana çıxarırıq
display_elf_header_info
