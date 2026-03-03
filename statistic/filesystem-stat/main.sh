#!/bin/bash

# ===== Список вывода =====
# 1. Общее число папок (включая вложения)
# 2. Топ 5 папок по весу по убыванию
# 3. Общее число файлов
# 4. Число конфигурационных файлов (.conf)
# 5. Число текстовых файлов
# 6. Исполняемых файлов
# 7. Логов (.log)
# 8. Архивов
# 9. Топ 10 файлов с самым болшим весом по убываниию (нужно указать путь, размер и тип)
# 10. Топ 10 исполняемых файлов по весу по убыванию (путь, размер, хеш)
# 11. Время выполнения скриипта

start_time=$(date +%s.%N)

source ./arg.sh


# ===== Количество папок =====
echo "Total number of folders (including all nested ones) = $(find "$dir" -mindepth 1 -type d | wc -l)"

# ===== Топ-5 самых тяжёлых папок =====
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
echo "$(find "$dir" -mindepth 1 -type d -print0 2>/dev/null \
    | xargs -0 du -sh 2>/dev/null \
    | sort -h -r \
    | head -n 5 \
    | awk '{print $2 ", " $1}' \
    | nl -w1 -s" - ")"

# ===== Количество файлов =====
echo "Total number of files = $(find "$dir" -type f | wc -l)"

echo "Number of:"
# ===== Количество конфигурационных файлов (.conf) =====
echo "Configuration files (with the .conf extension) = $(find "$dir" -type f -name "*.conf" 2>/dev/null | wc -l)"

# ===== Количество текстовых файлов =====
echo "Text files = $(find "$dir" -type f -print0 2>/dev/null \
    | xargs -0 file --mime-type 2>/dev/null \
    | awk -F: '$2 ~ /text\// {count++} END {print count}')"

# ===== Количество исполняемых файлов =====
echo "Executable files = $(find "$dir" -type f -executable 2>/dev/null | wc -l)"

# ===== Количество лог-файлов (.log) =====
echo "Log files (with the extension .log) = $(find "$dir" -type f -name "*.log" 2>/dev/null | wc -l)"

# ===== Количество архивов =====
echo "Archive files = $(find "$dir" -type f \( \
    -name "*.tar"   -o \
    -name "*.tar.gz" -o \
    -name "*.tgz"   -o \
    -name "*.tar.bz2" -o \
    -name "*.tbz2"  -o \
    -name "*.gz"    -o \
    -name "*.bz2"   -o \
    -name "*.xz"    -o \
    -name "*.zip"   -о \
    -name "*.7z"    -o \
    -name "*.rar" \
  \) 2>/dev/null | wc -l)"

# ===== Количество симлинков =====
echo "Symbolic links = $(find "$dir" -type l 2>/dev/null | wc -l)"

# ===== Топ-10 файлов =====
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
echo "$(find "$dir" -type f -print0 2>/dev/null \
    | xargs -0 du -sh 2>/dev/null \
    | sort -h -r \
    | head -n 10 \
    | while read -r size path; do
        file="${path##*/}"
        ext="${file##*.}"
        [[ "$file" == "$ext" ]] && ext="no extention"
        echo "$path, $size, $ext"
    done | nl -w1 -s" - ")"

# ===== Топ-10 исполняемых файлов =====
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
echo "$(find "$dir" -type f -executable -print0 2>/dev/null \
    | xargs -0 du -sh 2>/dev/null \
    | sort -h -r \
    | head -n 10 \
    | while read -r size path; do
        hash=$(md5sum "$path" 2>/dev/null | awk '{print $1}')
        echo "$path, $size, $hash"
    done | nl -w1 -s" - ")"


# ===== Время выполнения скрипта =====
end_time=$(date +%s.%N)
echo "Script execution time (in seconds) = $(awk "BEGIN {printf \"%.5f\", ${end_time}-${start_time}}")sec"
