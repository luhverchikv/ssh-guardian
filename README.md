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
- 🐧 **Универсальность** — поддержка SSH и консольного входа

---

## 📊 Получаемая информация

| Поле | Описание |
|------|----------|
| 👤 **Пользователь** | Имя пользователя Linux |
| 🌐 **IP-адрес** | Откуда выполнен вход |
| ⏰ **Время** | Точная дата и время входа |
| 💻 **Тип сессии** | SSH или Console |
| 📍 **Сервер** | Имя хоста сервера |

---

## 🛠 Установка

### 1. Клонирование репозитория

```bash
git clone https://github.com/YOUR_USERNAME/ssh-guardian.git
cd ssh-guardian
```

### 2. Настройка скрипта

Откройте `telegram_login_notify.sh` и укажите ваши данные:

```bash
TELEGRAM_BOT_TOKEN="ВАШ_ТОКЕН"
TELEGRAM_CHAT_ID="ВАШ_CHAT_ID"
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

## 📦 Использование

### Для SSH входов

Добавьте в конец файла `~/.bashrc`:

```bash
echo 'source ~/ssh-guardian/telegram_login_notify.sh' >> ~/.bashrc
```

Или для системного мониторинга (рекомендуется):

```bash
sudo cp telegram_login_notify.sh /usr/local/bin/telegram_login_notify.sh
sudo chmod +x /usr/local/bin/telegram_login_notify.sh
```

### Настройка PAM (для всех входов)

Создайте файл `/etc/pam.d/login-notify`:

```bash
sudo nano /etc/pam.d/login-notify
```

Добавьте содержимое:

```bash
session optional pam_exec.so /usr/local/bin/telegram_login_notify.sh
```

Добавьте в SSH PAM:

```bash
sudo nano /etc/pam.d/sshd
```

Добавьте строку:

```bash
session optional pam_exec.so /usr/local/bin/telegram_login_notify.sh
```

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

1. Проверьте правильность токена и Chat ID
2. Убедитесь, что бот добавлен в чат
3. Проверьте логи: `tail -f /var/log/auth.log`

### PAM ошибки

```bash
sudo chmod +x /usr/local/bin/telegram_login_notify.sh
sudo chown root:root /usr/local/bin/telegram_login_notify.sh
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