# Yandex-Disk
Простой скрипт Баш для резервного копирования файлов на Яндекс.Диск через API

# Особенности
авторизации OAuth
Нуждается только завитка (без WebDAV или Яндексом клиента)
шифрование GPG
Уведомление по электронной почте

# Подготовка
Необходимо получить TOKEN для работы скрипта с вашим Диском перейдите по ссылке https://oauth.yandex.ru/authorize?response_type=token&client_id=59ab22ca3f794a3b922935e2f8692985 и разрешите доступ к вашим данным. Скопируйте полученные данные в файл.

git clone https://github.com/ru-faraon/Yandex-Disk/blob/master/yad.sh
./yad.sh

# Создайте на рабочем компьютере GPG ключ
gpg2 --gen-key

# Настройки

# Yandex.Disk token.
token='xxxxxxxxxxxxxxxxxxxxxx'

# Отправить по электронной почте необходимо войти.
mailLog='yad@ya.ru'

# Отправить по электронной почте только когда ошибка.
mailLogErrorOnly=false

# Целевой каталог. Убедитесь, что каталог существует.
backupDir='LINUX-BACKUP'

# Имя файла журнала.
logFile=yad.log

# GPG шифрование UID.
GPGENCRYPTUID='xxxxxxxx'

# Применение
# Скопируйте файл в ЯНДЕКС.ДИСК:
./yad.sh -f /path/to/file/file_name

# Шифровать и скопировать файл на ЯНДЕКС.ДИСК:
./yad.sh -f /path/to/file/file_name -g username@server

# Скопируйте файл в ЯНДЕКС.ДИСК и уведомлять пользователя об ошибках:
./yad.sh -f /path/to/file/file_name -m user@localhost -e
