# ===== Сбор данных =====
# Timezone
offset_raw=$(date +%z)
sign=${offset_raw:0:1}
hours=${offset_raw:1:2}
hours=$((10#${offset_raw:1:2}))
timezone="$(timedatectl show -p Timezone --value) UTC $sign$hours"

# OS
if [ -f /etc/os-release ]; then
    . /etc/os-release # Импортируем файл
    os="$NAME"
    os_version="$VERSION"
    os_info="$os $os_version"
else
    os_info="error: no file /etc/os-release"
fi

# Uptime
uptime=$(uptime -p)
uptime=${uptime:3}

# Uptime_sec
if [ -f /proc/uptime ]; then
    uptime_sec="$(awk '{print $1}' /proc/uptime)"
else
    uptime_sec="error: no file /proc/uptime"
fi

# IP
ip=$(ip -4 addr show | awk '/inet / && $2 !~ /^127\./ {print $2; exit}')
cidr="${ip#*/}"
ip=${ip%/*}

# Netmask
cidr_to_netmask() {
    local netmask=""
    local cidr=$1
    local full_octets=$((cidr/8))
    local nonet_bits=$((cidr%8))

    for i in {1..4}; do
        if (( $i <= $full_octets )); then
            octet=255
        elif (( $i == $full_octets + 1 )); then
            octet=$(( 256 - 2**(8 - nonet_bits) ))
        else
            octet=0
        fi

        netmask+=$octet
        if [[ $i < 4 ]]; then
            netmask+="."
        fi
    done
    echo $netmask
}
netmask=$(cidr_to_netmask $cidr)

# Gateaway
Gateaway=$(ip route | awk '/^default/ {print $3; exit}')

# RAM
read -r ram_total_kb ram_used_kb ram_free_kb < <(free -k | awk '/Mem:/ {print $2, $3, $4}')
ram_total_gb=$(awk "BEGIN {printf \"%.3f\", $ram_total_kb/1024/1024}")
ram_used_gb=$(awk "BEGIN {printf \"%.3f\", $ram_used_kb/1024/1024}")
ram_free_gb=$(awk "BEGIN {printf \"%.3f\", $ram_free_kb/1024/1024}")

# Root space
read -r space_root_kb space_root_used_kb space_root_free_kb < <(df / | awk '/\/$/{print $2, $3, $4}')
space_root_mb=$(awk "BEGIN {printf \"%.2f\", $space_root_kb/1024}")
space_root_used_mb=$(awk "BEGIN {printf \"%.2f\", $space_root_used_kb/1024}")
space_root_free_mb=$(awk "BEGIN {printf \"%.2f\", $space_root_free_kb/1024}")
