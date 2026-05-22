# 🚀 ssh-guardian

> Уведомления о входе на сервер в Telegram

![Shell](https://img.shields.io/badge/Shell-Bash-green)
![Platform](https://img.shields.io/badge/Platform-Linux-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📖 Описание

`ssh-guardian` — это простой bash-скрипт, который отправляет уведомления в Telegram при каждом входе пользователя на сервер. Идеальное решение для мониторинга доступа к вашим серверам.

---

## ✨ Возможности

- 📩 **Мгновенные уведомления** — сообщение в Telegram сразу при входе
- 🔍 **Детальная информация** — кто, откуда, когда и как вошёл
- 🔒 **Безопасность** — работает через официальный API Telegram
- ⚙️ **Простая установка** — минимум настроек
- 🐧 **SSH мониторинг** — уведомления при каждом SSH-подключении

---

## 📊 Получаемая информация

| Поле | Описание |
|------|----------|
| 👤 **Пользователь** | Имя пользователя Linux |
| 🌐 **IP-адрес** | Откуда выполнен вход |
| ⏰ **Время** | Точная дата и время входа |
| 💻 **Тип сессии** | SSH |
| 📍 **Сервер** | Имя хоста сервера |

---

## 🛠 Установка

### 1. Клонирование репозитория

```bash
git clone https://github.com/luhverchikv/ssh-guardian.git
cd ssh-guardian
```

### 2. Установка переменных окружения

Добавьте в `~/.bashrc`:

```bash
echo 'export TELEGRAM_BOT_TOKEN="ВАШ_ТОКЕН"' >> ~/.bashrc
echo 'export TELEGRAM_CHAT_ID="ВАШ_CHAT_ID"' >> ~/.bashrc
```

Примените изменения:

```bash
source ~/.bashrc
```

### 3. Установка прав

```bash
chmod +x telegram_login_notify.sh
```

---

## 🔧 Настройка Telegram

### Получение Bot Token

1. Откройте Telegram
2. Найдите **@BotFather**
3. Отправьте `/newbot`
4. Следуйте инструкциям и сохраните токен

### Получение Chat ID

1. Найдите бота **@userinfobot**
2. Отправьте `/start`
3. Скопируруйте ваш Chat ID

---

## 📦 Установка через PAM (SSH)

### 1. Установка скрипта

```bash
# Скопируйте скрипт в системную директорию
sudo cp telegram_login_notify.sh /usr/local/bin/telegram_login_notify.sh

# Установите права на выполнение
sudo chmod +x /usr/local/bin/telegram_login_notify.sh
```

### 2. Настройка PAM для SSH

Откройте файл конфигурации PAM для SSH:

```bash
sudo nano /etc/pam.d/sshd
```

Добавьте следующую строку в конец файла:

```bash
session optional pam_exec.so /usr/local/bin/telegram_login_notify.sh
```

### 3. Перезапустите SSH

```bash
sudo systemctl restart sshd
```

---

> **Примечание:** Скрипт срабатывает только при SSH-подключении. При каждом новом входе вы получите уведомление в Telegram.

---

## 📱 Пример уведомления

```
🔐 Вход на сервер

📍 Сервер: my-server
👤 Пользователь: admin
🌐 IP-адрес: 192.168.1.100
💻 Тип сессии: SSH
📋 TTY: /dev/pts/0
⏰ Время: 2025-01-15 14:30:45
```

---

## 🔒 Безопасность

- ✅ Не хранит пароли
- ✅ Использует только read-only данные системы
- ✅ Токен бота хранится локально
- ✅ Не передаёт чувствительные данные

---

## 🐛 Устранение проблем

### curl не найден

```bash
sudo apt update && sudo apt install curl  # Debian/Ubuntu
sudo yum install curl                      # CentOS/RHEL
```

### Нет уведомлений

1. Проверьте, что переменные окружения установлены: `echo $TELEGRAM_BOT_TOKEN`
2. Убедитесь, что бот добавлен в чат
3. Проверьте логи: `sudo journalctl -u sshd`
4. Убедитесь, что строка `pam_exec.so` добавлена в `/etc/pam.d/sshd`

### PAM ошибки

```bash
# Проверьте права на скрипт
sudo chmod +x /usr/local/bin/telegram_login_notify.sh

# Проверьте владельца
sudo chown root:root /usr/local/bin/telegram_login_notify.sh

# Проверьте, что переменные окружения доступны
sudo bash -c 'echo $TELEGRAM_BOT_TOKEN'
```

---

## 🤝 Вклад

Pull requests приветствуются! Для крупных изменений сначала откройте issue для обсуждения.

---

## 📄 Лицензия

MIT License — используйте свободно!

---

## 👨‍💻 Автор

Создано с ❤️ для безопасности серверов