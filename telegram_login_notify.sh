#!/bin/bash

# ============================================
# Telegram Login Notification Script
# ============================================
# Этот скрипт отправляет уведомление в Telegram
# при каждом входе пользователя на сервер
# Токены берутся из переменных окружения
# ============================================

# ============================================
# НАСТРОЙКА - Переменные окружения
# ============================================
# Установите на сервере:
#   export TELEGRAM_BOT_TOKEN="ваш_токен"
#   export TELEGRAM_CHAT_ID="ваш_chat_id"
#
# Или добавьте в /etc/environment или ~/.bashrc
# ============================================

# Директория для маркеров (предотвращение дублей)
MARKER_DIR="/tmp/telegram-login-markers"

# Переменные из окружения
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID}"

# Функция для отправки сообщения в Telegram
send_telegram_message() {
    local message="$1"
    local bot_token="$TELEGRAM_BOT_TOKEN"
    local chat_id="$TELEGRAM_CHAT_ID"

    # URL API Telegram Bot
    local api_url="https://api.telegram.org/bot${bot_token}/sendMessage"

    # Отправка сообщения через curl
    curl -s -X POST "${api_url}" \
        -d chat_id="${chat_id}" \
        -d text="${message}" \
        -d parse_mode="HTML"
}

# Проверка - было ли уже отправлено уведомление для этой сессии
check_duplicate_session() {
    local tty="$1"
    local timestamp="$2"

    # Создаём директорию для маркеров если её нет
    mkdir -p "$MARKER_DIR"

    # Имя файла-маркера: TTY + первые 10 символов timestamp
    local marker_file="${MARKER_DIR}/$(basename ${tty})_${timestamp:0:10}"

    # Проверяем существование маркера
    if [ -f "$marker_file" ]; then
        return 1  # Дубликат - уже отправляли
    fi

    # Создаём маркер
    touch "$marker_file"

    # Удаляем маркеры старше 1 часа (cleanup)
    find "$MARKER_DIR" -type f -mmin +60 -delete 2>/dev/null

    return 0  # Не дубликат - можно отправлять
}

# Получение информации о входе
get_login_info() {
    local username="${PAM_USER:-$(whoami)}"
    local hostname="$(hostname)"
    local ip_address="${PAM_RHOST:-$(who am i | awk '{print $6}' | tr -d '()')}"
    local tty="${PAM_TTY:-$(tty)}"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local session_type="SSH"

    # Определение типа сессии
    if [ -z "$ip_address" ] || [ "$ip_address" = "localhost" ]; then
        ip_address=$(w | who | awk '{print $3}' | tail -1)
        if [ -z "$ip_address" ]; then
            ip_address="local"
        fi
        session_type="Console"
    fi

    echo "$username|$hostname|$ip_address|$tty|$timestamp|$session_type"
}

# Формирование сообщения
format_message() {
    local info="$1"
    IFS='|' read -r username hostname ip_address tty timestamp session_type <<< "$info"

    cat <<EOF
🔐 <b>Вход на сервер</b>

📍 <b>Сервер:</b> ${hostname}
👤 <b>Пользователь:</b> ${username}
🌐 <b>IP-адрес:</b> ${ip_address}
💻 <b>Тип сессии:</b> ${session_type}
📋 <b>TTY:</b> ${tty}
⏰ <b>Время:</b> ${timestamp}
EOF
}

# Главная функция
main() {
    # Проверяем тип сессии PAM
    # open_session = вход, close_session = выход
    if [ "$PAM_TYPE" = "close_session" ]; then
        exit 0  # При выходе ничего не делаем
    fi

    # Проверка наличия переменных окружения
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        echo "Ошибка: Установите переменные окружения TELEGRAM_BOT_TOKEN и TELEGRAM_CHAT_ID"
        exit 1
    fi

    # Проверка наличия curl
    if ! command -v curl &> /dev/null; then
        echo "Ошибка: curl не установлен"
        exit 1
    fi

    # Получение информации
    local login_info=$(get_login_info)
    IFS='|' read -r username hostname ip_address tty timestamp session_type <<< "$login_info"

    # Проверка на дубликат
    if ! check_duplicate_session "$tty" "$timestamp"; then
        echo "Уведомление уже отправлено для этой сессии (tty=$tty)"
        exit 0
    fi

    # Формирование и отправка сообщения
    local message=$(format_message "$login_info")
    send_telegram_message "$message"
}

# Запуск
main "$@"