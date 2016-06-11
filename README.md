# Yandex-Disk
Simpe bash script for backup files to Yandex.Disk via API


Features

OAuth authorization
Needs only curl (no webdav or yandex client)
GPG encryption
email notification


Usage

Copy file to Yandex Disk:

./yad.sh -f /path/to/file/file_name
Encrypt and copy file to Yandex Disk:

./yad.sh -f /path/to/file/file_name -g username@server
Copy file to Yandex Disk and notify user about errors

./yad.sh -f /path/to/file/file_name -m user@localhost -e
