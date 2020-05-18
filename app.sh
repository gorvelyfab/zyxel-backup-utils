#!/bin/bash

echo "Starting Zyxel Backup"
echo ""

app_script=`readlink -f $(which $0)`
app_path=$(dirname $app_script)
ouput_path=$1
today=$(date +%Y.%m.%d)
folder="$ouput_path/$today"

if ! [ -f "$app_path/sources.txt" ]; then
    echo "Error: No source file found in the App Folder '$app_path/sources.txt)'."
    exit 1
fi

if [ -d $folder ]; then
    rm -rf $folder
fi

mkdir -p $folder && cd $_

while read -r line && [[ -n $line ]]; do
    read -r mask username password <<<$line
    echo -e "Start network $mask...\u23F3" # Printing emoji ⏳
    nmap -sL $mask | awk '/Nmap scan report/{print $NF}' | while read -r ip && [[ -n $ip ]]; do
        "$app_path/ftp.sh" $ip $username $password $folder > /dev/null 2&>1
        if [[ $? -eq 0 ]]; then
            echo "Host $ip Success."
        else
            echo "Host $ip Failed."
        fi
    done
    echo -e "Finish network $mask \u2714\u2714\u2714" # Printing emoji ✔✔✔
    echo ""
done < "$app_path/sources.txt"

test -f "1" && rm -rf "1"

echo "Ending Zyxel Backup"
exit 0
