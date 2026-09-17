#!/bin/bash
# ================================================================
#  ONE-PASTE SERVER DEPLOY KIT
#  Разворачивает ВСЕ проекты с сервера-источника на любой новый
#  Usage: bash <(curl -sL <URL_TO_THIS_SCRIPT>)
# ================================================================
set -e
REPO="https://github.com/Afonya876/neko-backup"
BRANCH="main"
BASE="/root"

echo "=== [1/5] Установка зависимостей ==="
if command -v apt-get >/dev/null; then
  apt-get update -qq && apt-get install -y -qq python3 python3-venv python3-pip git curl nginx >/dev/null
elif command -v yum >/dev/null; then
  yum install -y -q python3 python3-pip git curl nginx >/dev/null
fi

echo "=== [2/5] Скачивание бэкапа из GitHub (приватный репо) ==="
# Если репо приватное — нужен токен: export GH_TOKEN=ghp_xxx
AUTH=""
if [ -n "$GH_TOKEN" ]; then AUTH="-H \"Authorization: token $GH_TOKEN\""; fi
cd /tmp
rm -f server_full_backup.tar.gz systemd_units.tar.gz
curl -sL $AUTH -o server_full_backup.tar.gz "$REPO/raw/$BRANCH/server_full_backup.tar.gz"
curl -sL $AUTH -o systemd_units.tar.gz "$REPO/raw/$BRANCH/systemd_units.tar.gz"
if [ ! -s server_full_backup.tar.gz ] || head -c1 server_full_backup.tar.gz | grep -q "<"; then
  echo "ERROR: не скачался архив. Если репо приватное — задай GH_TOKEN=ghp_xxx"; exit 1
fi

echo "=== [3/5] Распаковка проектов ==="
cd $BASE
tar xzf /tmp/server_full_backup.tar.gz
mkdir -p /opt && tar xzf /tmp/server_full_backup.tar.gz -C / --strip-components=0 opt/ etc/ 2>/dev/null || true
# если opt/etc уже в архиве с корня — распакуем второй раз выборочно:
tar tzf /tmp/server_full_backup.tar.gz | grep "^opt/" >/dev/null && tar xzf /tmp/server_full_backup.tar.gz -C / opt etc 2>/dev/null || true

echo "=== [4/5] systemd сервисы ==="
mkdir -p /etc/systemd/system
tar xzf /tmp/systemd_units.tar.gz -C /etc/systemd/system 2>/dev/null || true
systemctl daemon-reload

echo "=== [5/5] Python-окружения ==="
mkdir -p /root/_shared_venvs
python3 -m venv /root/_shared_venvs/bot-common 2>/dev/null || true
python3 -m venv /root/_shared_venvs/central-admin 2>/dev/null || true
# базовые пакеты для ботов:
/root/_shared_venvs/bot-common/bin/pip install -q aiogram python-dotenv requests 2>/dev/null || true

echo ""
echo "=========================================="
echo " ГОТОВО! Все проекты в /root и /opt"
echo " Запуск нужных ботов:"
echo "   systemctl start <service>   (список: systemctl list-units | grep bot)"
echo "=========================================="
