#!/bin/bash

# Подгружаем модули для скрипта
source ./color.sh
source ./logic.sh


# ===== Вывод собранных значений =====
print_color() {
    local key="$1"
    local val="$2"
    echo -e "${BColor1}${FColor1}${key}${RESET} = ${BColor2}${FColor2}${val}${RESET}"
}

print_color "HOSTNAME" "$HOSTNAME"
print_color "TIMEZONE" "$timezone"
print_color "USER" "$USER"
print_color "OS" "$os_info"
print_color "DATE" "$(date +"%d %b %Y %H:%M:%S")"
print_color "UPTIME" "$uptime"
print_color "UPTIME_SEC" "$uptime_sec sec"
print_color "IP" "${ip:-N/A}"
print_color "MASK" "${netmask:-N/A}"
print_color "GATEWAY" "${Gateaway:-N/A}"
print_color "RAM_TOTAL" "${ram_total_gb} GB"
print_color "RAM_USED" "${ram_used_gb} GB"
print_color "RAM_FREE" "${ram_free_gb} GB"
print_color "SPACE_ROOT" "${space_root_mb} MB"
print_color "SPACE_ROOT_USED" "${space_root_used_mb} MB"
print_color "SPACE_ROOT_FREE" "${space_root_free_mb} MB"

# Выводим схему цветов
echo -e "$color_scheme"