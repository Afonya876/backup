# srv-bkp-185c018f

**Сервер-источник:** 144.31.53.210 · **Дата:** 18.09.2026

## Быстрый деплой на новый сервер (одна команда)

```bash
bash <(curl -sL https://raw.githubusercontent.com/Afonya876/srv-bkp-185c018f/main/install.sh)
```

Скрипт сам:
1. Ставит python3, nginx, pip
2. Скачивает 2 архива (6 частей), склеивает их
3. Распаковывает 33 проекта в `/root` и сайты в `/opt`
4. Разворачивает 58 systemd-сервисов и nginx-конфиги
5. Создаёт Python-venv с aiogram

После установки запуск ботов:

```bash
# один бот
systemctl start central-admin-v2-bot

# список всех сервисов
systemctl list-unit-files | grep -iE "bot|admin"

# запустить ВСЁ сразу
for s in $(systemctl list-unit-files --type=service | grep -iE 'bot|admin|shop|monitor|review|neon' | awk '{print $1}'); do systemctl start $s; done
```

## Что в бэкапе

### backup.part1-3of3 → `/root` (33 проекта, 54 МБ)

| Категория | Проекты |
|---|---|
| **Мульти-админка** | `central_admin` (бот+webapp+мини-апп), `multy_admin` |
| **gray_v2** (9 ботов) | monster-1, monster-2, B_Green_Day, KFC_vip1, flame4gngcxk, ugtop20_probot, centurypass6, evila_bot |
| **Соло-боты** | 11-7, 4dmap, BigNewSanders, Black, BOBRIK, Bpclub9shop, DONBASS, Evilco, GlassCr, GUS, KFC, kissmyacid, Larek, Lepricon, Mak, MDZ24SK, Miami, NEON, payopt_poshta, piohano, Samurai, sc420, Shishka, SOLO, tds24, TotalBlack, VARIK, VIP, WYVERN |

В каждом `.env` с токенами — боты стартуют сразу после `systemctl start`.

### opt.part1-3of3 → `/opt` + `/etc` (72 МБ)

| Что | Где |
|---|---|
| Сайты | `/opt/review-site`, `/opt/review-site-vidguky`, `/opt/ful_moon_monitor`, `/opt/smm2`, `/opt/solo-pw` |
| NEON бот | `/opt/neon` |
| Nginx конфиги (6 сайтов) | `/etc/nginx` |
| Systemd юниты (58 сервисов) | `/etc/systemd/system` |

## Структура

```
backup/
├── install.sh          # деплой-скрипт (одна команда)
├── backup.part1of3     # /root проекты, часть 1 (20 МБ)
├── backup.part2of3     # /root проекты, часть 2 (20 МБ)
├── backup.part3of3     # /root проекты, часть 3 (12 МБ)
├── opt.part1of3        # /opt сайты + nginx + systemd, часть 1 (25 МБ)
├── opt.part2of3        # часть 2 (25 МБ)
└── opt.part3of3        # часть 3 (19 МБ)
```

## Восстановление вручную (без install.sh)

```bash
# скачать и склеить
curl -sL https://raw.githubusercontent.com/Afonya876/srv-bkp-185c018f/main/backup.part1of3 -o p1
curl -sL https://raw.githubusercontent.com/Afonya876/srv-bkp-185c018f/main/backup.part2of3 -o p2
curl -sL https://raw.githubusercontent.com/Afonya876/srv-bkp-185c018f/main/backup.part3of3 -o p3
cat p1 p2 p3 > root_backup.tar.gz && rm p1 p2 p3

curl -sL https://raw.githubusercontent.com/Afonya876/srv-bkp-185c018f/main/opt.part1of3 -o o1
curl -sL https://raw.githubusercontent.com/Afonya876/srv-bkp-185c018f/main/opt.part2of3 -o o2
curl -sL https://raw.githubusercontent.com/Afonya876/srv-bkp-185c018f/main/opt.part3of3 -o o3
cat o1 o2 o3 > opt_backup.tar.gz && rm o1 o2 o3

# развернуть
tar xzf root_backup.tar.gz -C /root
tar xzf opt_backup.tar.gz -C /
systemctl daemon-reload
```

## Примечания

- Исключено из бэкапа: venv, node_modules, `__pycache__`, логи, `.bak`-файлы, старые бэкапы каталогов
- Актуальный каталог monster-2 и юзеры ботов включены в `data/*.json`
- Если GitHub спросит верификацию устройства при входе — код приходит на meganeew@proton.me
