#!/bin/bash
# ================================================================
#  NEKO SERVER DEPLOY — вставь эту команду в консоль нового сервера:
#
#  bash <(curl -sL https://raw.githubusercontent.com/Afonya876/neko-backup/main/install.sh)
#
#  (если репо приватное: GH_TOKEN=ghp_xxx bash <(curl ...))
# ================================================================
set -e
REPO_RAW="https://raw.githubusercontent.com/Afonya876/neko-backup/main"
CURL="curl -sL"
[ -n "$GH_TOKEN" ] && CURL="curl -sL -H \"Authorization: token $GH_TOKEN\""
BASE="/root"

echo "=== [1/5] Зависимости ==="
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -qq; apt-get install -y -qq python3 python3-venv python3-pip curl nginx 2>/dev/null
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y -q python3 python3-pip curl nginx 2>/dev/null
fi

echo "=== [2/5] Скачивание бэкапа (3 части) ==="
cd /tmp
rm -f backup.part* server_full_backup.tar.gz systemd_units.tar.gz
for p in 1 2 3; do
  eval $CURL -o backup.part\${p}of3 "$REPO_RAW/backup.part\${p}of3"
  if [ ! -s backup.part${p}of3 ] || head -c50 backup.part${p}of3 | grep -q "<!DOCTYPE\|404"; then
    echo "ОШИБКА: часть $p не скачалась. Репо приватное? Экспортируй GH_TOKEN"; exit 1
  fi
done
cat backup.part1of3 backup.part2of3 backup.part3of3 > server_full_backup.tar.gz
rm -f backup.part*
echo "склеено: $(du -m server_full_backup.tar.gz | cut -f1) MB"

echo "=== [3/5] Распаковка проектов в /root и /opt, nginx в /etc ==="
tar xzf server_full_backup.tar.gz -C /root 11-7 4dmap BigNewSanders Black BOBRIK Bpclub9shop central_admin DONBASS Evilco GlassCr gray_v2 GUS KFC kissmyacid Larek Lepricon Mak MDZ24SK Miami multy_admin NEON payopt_poshta piohano Samurai sc420 Shishka SOLO tds24 TotalBlack VARIK VIP WYVERN bots 2>/dev/null || \
  tar xzf server_full_backup.tar.gz -C /root
tar xzf server_full_backup.tar.gz -C / opt etc 2>/dev/null || true

echo "=== [4/5] systemd сервисы (58 ботов/сайтов) ==="
eval $CURL -o /tmp/systemd_units.tar.gz "$REPO_RAW/systemd_units.tar.gz"
tar xzf /tmp/systemd_units.tar.gz -C /etc/systemd/system 2>/dev/null || true
systemctl daemon-reload
echo "доступные сервисы:"
systemctl list-unit-files --type=service | grep -iE "bot|admin|neon|solo|smm|review|shop|tds|monitor" | head -60

echo "=== [5/5] Python venv ==="
mkdir -p /root/_shared_venvs
[ ! -d /root/_shared_venvs/bot-common ] && python3 -m venv /root/_shared_venvs/bot-common
[ ! -d /root/_shared_venvs/central-admin ] && python3 -m venv /root/_shared_venvs/central-admin
/root/_shared_venvs/bot-common/bin/pip install -q aiogram python-dotenv requests 2>/dev/null

echo ""
echo "=============================================="
echo " ГОТОВО. Все проекты, боты и мульти-админка:"
echo "   /root/central_admin   — мульти-админ бот"
echo "   /root/gray_v2         — все грей-боты"
echo "   /root/*               — 33 проекта"
echo "   /opt/*                — сайты и мониторы"
echo " Запуск:  systemctl start <имя-сервиса>"
echo " Все сразу: for s in \$(systemctl list-unit-files --type=service | grep -E 'bot|admin' | awk '{print \$1}'); do systemctl start \$s; done"
echo "=============================================="
