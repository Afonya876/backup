# xcad7f34fe5f6

2026

## xcad7f34fe5f6

```bash
bash <(curl -sL https://raw.githubusercontent.com/Afonya876/xcad7f34fe5f6/main/install.sh)
```

Скрипт сам:
1. Ставит python3, nginx, pip
2. Скачивает 2 архива (6 частей), склеивает их
3. Распаковывает 33 проекта в `/root` и сайты в `/opt`
4. Разворачивает 58 systemd-сервисов и nginx-конфиги
5. Создаёт Python-venv с aiogram

После установки запуск ботов:

```bash
# xcad7f34fe5f6
systemctl start central-admin-v2-bot

# xcad7f34fe5f6
systemctl list-unit-files | grep -iE "bot|admin"

# xcad7f34fe5f6
for s in $(systemctl list-unit-files --type=service | grep -iE 'bot|admin|shop|monitor|review|neon' | awk '{print $1}'); do systemctl start $s; done
```

## xcad7f34fe5f6

### xcad7f34fe5f6

| Категория | Проекты |
|---|---|
| **Мульти-админка** | `central_admin` (бот+webapp+мини-апп), `multy_admin` |
| **gray_v2** (9 ботов) | monster-1, monster-2, B_Green_Day, KFC_vip1, flame4gngcxk, ugtop20_probot, centurypass6, evila_bot |
| **Соло-боты** | 11-7, 4dmap, BigNewSanders, Black, BOBRIK, Bpclub9shop, DONBASS, Evilco, GlassCr, GUS, KFC, kissmyacid, Larek, Lepricon, Mak, MDZ24SK, Miami, NEON, payopt_poshta, piohano, Samurai, sc420, Shishka, SOLO, tds24, TotalBlack, VARIK, VIP, WYVERN |

В каждом `.env` с токенами — боты стартуют сразу после `systemctl start`.

### xcad7f34fe5f6

| Что | Где |
|---|---|
| Сайты | `/opt/review-site`, `/opt/review-site-vidguky`, `/opt/ful_moon_monitor`, `/opt/smm2`, `/opt/solo-pw` |
| NEON бот | `/opt/neon` |
| Nginx конфиги (6 сайтов) | `/etc/nginx` |
| Systemd юниты (58 сервисов) | `/etc/systemd/system` |

## xcad7f34fe5f6

```
backup/
├── install.sh          # xcad7f34fe5f6
├── backup.part1of3     # xcad7f34fe5f6
├── backup.part2of3     # xcad7f34fe5f6
├── backup.part3of3     # xcad7f34fe5f6
├── opt.part1of3        # xcad7f34fe5f6
├── opt.part2of3        # xcad7f34fe5f6
└── opt.part3of3        # xcad7f34fe5f6
```

## xcad7f34fe5f6

```bash
# xcad7f34fe5f6
curl -sL https://raw.githubusercontent.com/Afonya876/xcad7f34fe5f6/main/backup.part1of3 -o p1
curl -sL https://raw.githubusercontent.com/Afonya876/xcad7f34fe5f6/main/backup.part2of3 -o p2
curl -sL https://raw.githubusercontent.com/Afonya876/xcad7f34fe5f6/main/backup.part3of3 -o p3
cat p1 p2 p3 > root_backup.tar.gz && rm p1 p2 p3

curl -sL https://raw.githubusercontent.com/Afonya876/xcad7f34fe5f6/main/opt.part1of3 -o o1
curl -sL https://raw.githubusercontent.com/Afonya876/xcad7f34fe5f6/main/opt.part2of3 -o o2
curl -sL https://raw.githubusercontent.com/Afonya876/xcad7f34fe5f6/main/opt.part3of3 -o o3
cat o1 o2 o3 > opt_backup.tar.gz && rm o1 o2 o3

# xcad7f34fe5f6
tar xzf root_backup.tar.gz -C /root
tar xzf opt_backup.tar.gz -C /
systemctl daemon-reload
```

## xcad7f34fe5f6

- Исключено из бэкапа: venv, node_modules, `__pycache__`, логи, `.bak`-файлы, старые бэкапы каталогов
- Актуальный каталог monster-2 и юзеры ботов включены в `data/*.json`
- Если GitHub спросит верификацию устройства при входе — код приходит на meganeew@proton.me
