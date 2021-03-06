#!/bin/bash

# ---------- SETTINGS -------------

# Yandex.Disk token
token=''

# Целевой каталог. Убедитесь, что каталог существует.
backupDir='LINUX-BACKUP'

# Имя файла журнала.
logFile=yad.log

# GPG шифрование UID.
GPGENCRYPTUID=''

# Отправить по электронной почте необходимо войти.
mailLog=''

# Отправить по электронной почте только ошибка.
mailLogErrorOnly=false

# ---------- FUNCTIONS ------------

function usage
{
cat <<EOF

USAGE: $0 OPTIONS

OPTIONS:

  -h  Показать это сообщение
  -f  <Имя файла> Указывает имя файла для загрузки
  -g  <UID> Указать GPG UID
  -m  <email@address> Укажите электронную почту для регистрации
  -e  Отправить письмо если только ошибка

EOF
}

function gpgEncrypt()
{
    gpg2 -e -r $GPGENCRYPTUID $FILENAME
}

function mailing()
{
    # Function's arguments:
    # $1 -- email subject
    # $2 -- email body
    if [ ! $mailLog = '' ];then
        if [ "$mailLogErrorOnly" == true ];
        then
            if echo "$1" | grep -q 'error'
            then   
                echo "$2" | mail -s "$1" $mailLog > /dev/null
            fi
        else
            echo "$2" | mail -s "$1" $mailLog > /dev/null
        fi
    fi
}


function logger()
{
    echo "["`date "+%Y-%m-%d %H:%M:%S"`"] File $FILENAME: $1" >> $logFile
}

function parseJson()
{
    local output
    regex="(\"$1\":[\"]?)([^\",\}]+)([\"]?)"
    [[ $2 =~ $regex ]] && output=${BASH_REMATCH[2]}
    echo $output
}

function checkError()
{
    echo $(parseJson 'error' "$1")
}

function getUploadUrl()
{
    local output
    local json_out
    local json_error
    json_out=`curl -s -H "Authorization: OAuth $token" https://cloud-api.yandex.net:443/v1/disk/resources/upload/?path=$backupDir/$backupName&overwrite=true`
    json_error=$(checkError "$json_out")
    if [[ $json_error != '' ]];
    then
	    logger "Yandex Disk error: $json_error"
        mailing "Yandex Disk backup error" "ERROR copy file $FILENAME. Yandex Disk error: $json_error"
        exit 1	
    else
	    output=$(parseJson 'href' $json_out)
	    echo $output
    fi
}

function uploadFile
{
    local json_out
    local uploadUrl
    local json_error
    uploadUrl=$(getUploadUrl)
    if [[ $uploadUrl != '' ]];
    then
	    json_out=`curl -s -T $1 -H "Authorization: OAuth $token" $uploadUrl`
	    json_error=$(checkError "$json_out")
	if [[ $json_error != '' ]];
	then
	    logger "Yandex Disk error: $json_error"
        mailing "Yandex Disk backup error" "ERROR copy file $FILENAME. Yandex Disk error: $json_error"

	else
	    logger "Copying file to Yandex Disk success"
        mailing "Yandex Disk backup success" "SUCCESS copy file $FILENAME"

	fi
    else
	echo 'Some errors occured. Check log file for detail'
	    exit 1
    fi
}

function preUpload()
{
    if [ ! $GPGENCRYPTUID = '' ];
    then
	    gpgEncrypt
	    FILENAME=$FILENAME.gpg
    fi

    backupName=`date "+%Y%m%d-%H%M"`_$(basename $FILENAME)
}

function postUpload()
{
    if [ ! $GPGENCRYPTUID = '' ];
    then
	    rm $FILENAME
    fi
}

# --------------- OPTIONS -------------

while getopts ":f:g:m:he" opt; do
    case $opt in
	h)
	    usage
	    exit 1
	    ;;
	f)
	    FILENAME=$OPTARG

	    if [ ! -f $FILENAME ];
	    then
		    echo "File not found: $FILENAME"
		    logger "File not found"
            mailing "Yandex Disk backup error" "ERROR copy file $FILENAME. File not found."
		    exit 1
	    fi
	    ;;
	g)
	    GPGENCRYPTUID=$OPTARG
	    ;;
	e)
	    mailLogErrorOnly=true
	    ;;
    m)
        mailLog=$OPTARG
        ;;
	\?)
	    echo "Invalid option: -$OPTARG. $0 -h for help" >&2
	    exit 1
	    ;;
	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    exit 1
	    ;;
    esac
done

# --------------- MAIN ----------------

if [[ -z $FILENAME ]]
then
    usage
    exit 1
fi

preUpload

uploadFile $FILENAME

postUpload

