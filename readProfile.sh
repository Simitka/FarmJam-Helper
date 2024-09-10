#!/bin/zsh

# Проверка наличия параметра с названием файла
if [ -z "$1" ]; then
  echo "Ошибка: Не указано название JSON файла."
  echo "Использование: $0 <название_json_файла> [интервал_в_секундах]"
  exit 1
fi

# Задаем путь к файлу на устройстве
json_file=$1
file_path="/sdcard/Android/data/farm.parking.game/files/profiles/$json_file"

# Функция для чтения, форматирования и вывода файла
read_file() {
  clear  # Очищаем консоль перед выводом
  update_count=$((update_count + 1))  # Увеличиваем счетчик обновлений
  current_time=$(date "+%Y-%m-%d %H:%M:%S")  # Текущее время

  # Информация вверху
  if [ "$interval" -gt 0 ]; then
    echo "\033[1mЧтобы завершить скрипт нажми Control+C\033[0m"
    echo ""
    echo "Интервал обновления: $interval секунд"
    echo "Количество обновлений: $update_count"
    echo "Последнее обновление: $current_time"
    echo "-------------------------------"
  fi
  
  # Чтение и вывод файла
  echo "Чтение файла: $file_path"
  adb shell "cat $file_path" | jq .
  echo "-------------------------------"
}

# Проверка на наличие второго параметра
if [ -z "$2" ]; then
  # Запрос частоты обновления у пользователя
echo "-------------------------------"  
echo "Введите частоту обновления в секундах."
  echo "\033[3mИли нажмите Enter, чтобы прочитать файл один раз и завершить выполнение скрипта\033[0m"

  # Чтение ввода пользователя
  read user_input

  # Проверка, является ли ввод числом больше нуля
  if [[ "$user_input" =~ ^[0-9]+$ ]] && [ "$user_input" -gt 0 ]; then
    interval=$user_input
  else
    # Если ввод пустой, установить интервал в 0 и завершить выполнение после первого чтения
    interval=0
  fi
else
  # Используем переданный интервал
  interval=$2
fi

# Переменная для подсчета обновлений
update_count=0

# Первоначальная очистка и чтение файла
clear
read_file

# Бесконечный цикл для обновления вывода, если интервал больше 0
while [ "$interval" -gt 0 ]; do
  sleep $interval
  read_file
done
