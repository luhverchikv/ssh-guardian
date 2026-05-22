#!/bin/bash

# ============================================
# Telegram Login Notification Script
# ============================================
# Этот скрипт отправляет уведомление в Telegram
# при каждом входе пользователя на сервер
# ============================================

# ============================================
# НАСТРОЙКА - Замените значения ниже
# ============================================
TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
TELEGRAM_CHAT_ID="YOUR_CHAT_ID_HERE"
# ============================================

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
    # Проверка наличия токена и chat_id
    if [ "$TELEGRAM_BOT_TOKEN" = "YOUR_BOT_TOKEN_HERE" ] || \
       [ "$TELEGRAM_CHAT_ID" = "YOUR_CHAT_ID_HERE" ]; then
        echo "Ошибка: Установите TELEGRAM_BOT_TOKEN и TELEGRAM_CHAT_ID"
        exit 1
    fi

    # Проверка наличия curl
    if ! command -v curl &> /dev/null; then
        echo "Ошибка: curl не установлен"
        exit 1
    fi

    # Получение информации и отправка уведомления
    local login_info=$(get_login_info)
    local message=$(format_message "$login_info")

    send_telegram_message "$message"
}

# Запуск
main "$@"
