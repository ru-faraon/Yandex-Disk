# Yandex-Disk
Simpe bash script for backup files to Yandex.Disk via API


# Features

OAuth authorization
Needs only curl (no webdav or yandex client)
GPG encryption
email notification

# Подготовка

Необходимо получить TOKEN для работы скрипта с вашим Диском перейдите по ссылке https://oauth.yandex.ru/authorize?response_type=token&client_id=59ab22ca3f794a3b922935e2f8692985 и разрешите доступ к вашим данным. Скопируйте полученные данные в файл.

git clone https://github.com/ru-faraon/Yandex-Disk/blob/master/yad.sh
./yad.sh

# Usage

# Copy file to Yandex Disk:

./yad.sh -f /path/to/file/file_name
Encrypt and copy file to Yandex Disk:

./yad.sh -f /path/to/file/file_name -g username@server
Copy file to Yandex Disk and notify user about errors

./yad.sh -f /path/to/file/file_name -m user@localhost -e
