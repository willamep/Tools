#!/bin/bash

numb_correct() {
	local num=$1
	local arg_num=$2
	
	if [[ "$num" != "0" && ! "$num" =~ ^[1-9][0-9]*$ ]]; then
		printf 'Ошибка: Некорректное значение %d аргумента "%s"' $arg_num $num
		exit 1
	fi
}

string_len() {
	local string=$1
	local max_len=$2
	local arg_num=$3

	if [[ ${#string} -gt max_len ]]; then
		printf 'Ошибка: аргумент %d длиннее %d символов "%s"\n' $arg_num $max_len $string
		exit 1
	fi
}

string_letters() {
	local string=$1
	local arg_num=$2

	if [[ ! $string =~ ^[A-Za-z]+$ ]]; then
		printf 'Ошибка: аргумент %d содержит недопустимые символы "%s"\n' $arg_num $string
		exit 1
	fi
}

string_seen () {	
	local -A seen # Ассоциативный массив для проверки уникальности
	local string=$1 
	local -n letters=$2 # Ссылка на глобальный индексный массив  
	local arg_num=$3

	for (( i=0; i<${#string}; i++ )); do
		local ch=${string:i:1}
		if [[ -n ${seen[$ch]} ]]; then
			printf 'Ошибка: аргумент %d имеет повторяющийся символ "%c"\n' $arg_num $ch
			exit 1
		fi
		letters+=( $ch ) # Сохраняем порядок в обынчый массив
		seen[$ch]=1 # Сохраняем ключ в ассоц.массив для проверки уникальности
	done
}

correct_form() {
	local option=$1

	local tmp_middle=${option#"$file_name"}
	local middle=${tmp_middle%"$extention"}

	if [[ "$middle" != "." ]]; then
		printf 'Ошибка: Некорректное значение 5 аргумента "%s"' $option
		exit 1
	fi
}

correct_5_option() {
	local option=$1

	correct_form $option

	string_len $file_name 7 5
	string_len $extention 3 5
	
	string_letters $file_name 5
	string_letters $extention 5
	
	string_seen $file_name $2 5
	string_seen $extention $3 5
}


path="$1"
dir_count="$2"
string="$3"
declare -a letters_dir
file_count="$4"
file_name="${5%%.*}"
declare -a letters_file
extention="${5##*.}"
declare -a letters_extention
file_size="${6%"kb"}"

# Количество аргументов
if (( $# != 6 )); then
	printf 'Ошибка: Неверное количество аргументов. Введите 6 аргументов.\n'
	printf 'Для справки %s -h (--help)\n' $0
	exit 1
fi

# Абсолютный путь
if [[ "$path" != /* ]]; then 
	printf 'Ошибка: Указан не абсолютный путь.\n'
	exit 1
elif [[ ! -d "$path" ]]; then
	printf 'Ошибка: Директория не существует'
	exit 1
fi
path="${path%/}/" # Нормализуем путь, чтобы он всегда заканчивался на /

# Количество вложенных папок
numb_correct $dir_count 2

# Список букв анлийского алфавита
string_len $string 7 3
string_letters $string 3
string_seen $string letters_dir 3

# Количество файлов в каждой созданной папке
numb_correct $file_count 4

# Буквы для названия файла и расширения
correct_5_option $5 letters_file letters_extention

# Размер файлов
numb_correct $file_size 6
if (( file_size < 1 || file_size > 100 )); then
	printf 'Введённое число %d не входит в доступный диапазон [1;100]\n' $file_size
	exit 1
fi