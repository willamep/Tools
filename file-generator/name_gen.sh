#!/bin/bash

date=$(date '+%d%m%y')

# gen_dir и gen_file похожи, отличаются путём, способом создания и немного названиями
# Метод генерации имени используется одинаковый 
gen_dir() {
    local -n letters=$1 # Индексный массив, содержащий все знаки и их порядок
    local -A key # Ассоциативный массив для учёта количества знаков для вывода
    local name_len=$(init_name_len ${#letters[@]}) # Узнаём длину названия Заполняем ассоциативный массив и вычисляем количество знаков для 1 вывода
    init_first_position $name_len letters key

    # Генерируем папки и их названия
    for (( c=0; c<${dir_count}; c++ )); do
        mkdir "${path}$(gen_name $name_len letters key)_$date" 2>/dev/null
        update_array name_len letters key
    done
}

gen_file() {
    local path="$1"
    local -n letters=$2 # Индексный массив, содержащий все знаки и их порядок
    local -A key # Ассоциативный массив для учёта количества знаков для вывода
    local name_len=$(init_name_len ${#letters[@]}) # Узнаём длину названия Заполняем ассоциативный массив и вычисляем количество знаков для 1 вывода
    init_first_position $name_len letters key

    # Генерируем папки и их названия
    for (( c=0; c<$file_count; c++ )); do
        dd if=/dev/zero of="${path}$(gen_name $name_len letters key)_$date.$extention" bs=1K count=$file_size status=none
        update_array name_len letters key
    done
}

# Генерирует 1 последовательность для имени
gen_name() {
    local name_len=$1
    local -n letters_sym=$2 
    local -n key_sym=$3
    local letter_count=${#letters_sym[@]}
    local name="" # сгенерированное имя папки/файла
    
    # Цикл, который проходится по всем символам
    for (( i=0; i<$letter_count; i++ )); do
        # Цикл, который генерирует нужное количество каждого символа
        for (( j=0; j<${key_sym[${letters_sym[i]}]}; j++ )); do
            name+="${letters_sym[i]}"
        done
    done
    
    echo "$name"    
}

# Устанавливаем минимальную длинну последовательности букв
init_name_len() {
    if (( $1<4 )); then
        echo '4'
    else
        echo "$1"
    fi
}

# Заполняем -A массив; первый вывод будет производиться по данным из его ключей. 
init_first_position() {
    local name_len=$1
    local -n letters_sym=$2 
    local -n key_sym=$3
    local letter_count=${#letters_sym[@]} # Количество символов в индексном массиве
    
    # Количество повторений 1 символа при первом выводе
    local first=$(( name_len - letter_count + 1 ))

    # Заполняем ассоциативный массив
    key_sym[${letters_sym[0]}]=$first
    for (( i=1; i<letter_count; i++ )); do
        key_sym[${letters_sym[$i]}]=1
    done
}

# Обновление значений в -A массиве
update_array() {
    local -n name_len_sym=$1
    local -n letters_sym=$2 
    local -n key_sym=$3

    # Находит первую букву, которая повторяется несколько раз
    # Уменьшает её количество на 1 и увеличивает количество следующей буквы
    for (( i=0; i<$(( ${#letters_sym[@]} - 1 )); i++ )); do
        if (( key_sym[${letters_sym[$i]}] != 1 )); then
            (( key_sym[${letters_sym[$i]}]-- ))
            (( key_sym[${letters_sym[$i+1]}]++ ))
            return 0
        fi
    done

    # Если количество всех букв в выводе, кроме последней =0
    # Добавляется место под ещё 1 символ и последовательность заново инициализируется
    (( name_len_sym++ ))
    init_first_position $name_len_sym $2 $3
}



