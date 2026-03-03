# ===== Подгрузка конфига =====
config_file="./config.conf"

# Дефолтные цвета
def_BColor1=6 # black
def_FColor1=2 # red
def_BColor2=6 # black
def_FColor2=4 # blue

# если конфиг существует — подгружаем
if [[ -f "$config_file" ]]; then
    # ожидается формат key=value без пробелов
    source "$config_file"
fi

# Подгружаем цвета из конфига, если значения нет или оно некорректно, оставляем дефолтное
check_val() {
    local conf_val=$1
    local def_val=$2

    if [[ -z "$def_val" ]]; then
        echo "$def_val"
    elif ! [[ $conf_val =~ ^[1-6]$ ]]; then
        # echo "Warning: Некорректный параметр в конфиге. Сейчас: '$conf_val'"
        # echo "Параметр заменён на дефолтный"
        echo "$def_val"
    else
        echo "$conf_val"
    fi
}

BColor1=$(check_val "$column1_background" "$def_BColor1")
FColor1=$(check_val "$column1_font_color" "$def_FColor1")
BColor2=$(check_val "$column2_background" "$def_BColor2")
FColor2=$(check_val "$column2_font_color" "$def_FColor2")

# Проверяем одинаковый ли цвет фона и текста
if [[ "$BColor1" == "$FColor1" ]]; then
    BColor1="$def_BColor1"
    FColor1="$def_FColor1"
    echo "В конфиге фон и текст названия значения одинаковые, поэтому выставлены дефолтные"
fi
if [[ "$BColor2" == "$FColor2" ]]; then
    BColor2="$def_BColor2"
    FColor2="$def_FColor2"
    echo "В конфиге фон и текст значения одинаковые, поэтому выставлены дефолтные"
fi


# ===== Формируем вывод цветовой схемы =====
color_from() {
    local val=$1
    local def_val=$2
    local first=""
    local second=""

    if [[ $val == $def_val ]]; then
        first=default
    else
        first=$val
    fi

    case $val in
        1) second=white ;;
        2) second=red ;;
        3) second=green ;;
        4) second=blue ;;
        5) second=purple ;;
        6) second=black ;;
    esac
    
    echo "$first ($second)"
}

line1="Column 1 background = $(color_from "$BColor1" "$def_BColor1")"
line2="Column 1 font color = $(color_from "$FColor1" "$def_FColor1")"
line3="Column 2 background = $(color_from "$BColor2" "$def_BColor2")"
line4="Column 2 font color = $(color_from "$FColor2" "$def_FColor2")"
color_scheme="\n${line1}\n${line2}\n${line3}\n${line4}"


# ===== Обработка цвета =====
# 1 — white, 2 — red, 3 — green, 4 — blue, 5 — purple, 6 — black
# Функции, которые возращают код ANSI-цвета
FontColor() {
    case $1 in
	    1) echo 37 ;; # white
        2) echo 31 ;; # red
        3) echo 32 ;; # green
        4) echo 34 ;; # blue
        5) echo 35 ;; # purple
        6) echo 30 ;; # black
    esac
}
BackColor() {
    case $1 in
	    1) echo 47 ;; # white
        2) echo 41 ;; # red
        3) echo 42 ;; # green
        4) echo 44 ;; # blue
        5) echo 45 ;; # purple
        6) echo 40 ;; # black
    esac
}
# Переменные, в которых будет храниться последовательность для применения кода ANSI-цвета
BColor1="\e[$(BackColor $BColor1)m"
FColor1="\e[$(FontColor $FColor1)m"
BColor2="\e[$(BackColor $BColor2)m"
FColor2="\e[$(FontColor $FColor2)m"
RESET="\e[0m"
