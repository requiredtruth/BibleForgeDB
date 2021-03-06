#!/bin/bash

# BibleForge
#
# @date    12-15-10
# @version 1.0
# @link    http://BibleForge.com
# @license MIT License (MIT)
# @author  BibleForge <info@bibleforge.com>

# This program exports the databases used by BibleForge.
# This is designed for Unix-like systems.

printf "Enter database name (bf): "
read mysqlDataBase

if [ "$mysqlDataBase" = "" ]; then
    mysqlDataBase="bf"
fi


printf "Enter username (root): "
read mysqlUserName

if [ "$mysqlUserName" = "" ]; then
    mysqlUserName="root"
fi


printf "Enter password: "
# Turn off typing echo.
stty -echo
read mysqlPassword
# Turn typing echo back on.
stty echo
# Since "echo" was turned off, the return character is not caught, so the script needs to insert a line break manually.
# NOTE: This creates two line breaks because "echo" automatically adds a line break.
echo $'\n'

echo "Exporting data...please wait...";

mysqldump --add-locks=false --lock-tables=false -u "$mysqlUserName" -h localhost -p"$mysqlPassword" "$mysqlDataBase" bible_original morphology | gzip -9 > bible_original.sql.gz

mysqldump --add-locks=false --lock-tables=false -u "$mysqlUserName" -h localhost -p"$mysqlPassword" "$mysqlDataBase" bible_en bible_en_html bible_en_verses | gzip -9 > bible_en_all.sql.gz

# There is no morphology for bible_en_em, yet.
mysqldump --add-locks=false --lock-tables=false -u "$mysqlUserName" -h localhost -p"$mysqlPassword" "$mysqlDataBase" bible_en_em bible_en_em_html bible_en_em_verses | gzip -9 > bible_en_em_all.sql.gz

# Simplified Chinese has no morphology table.
mysqldump --add-locks=false --lock-tables=false -u "$mysqlUserName" -h localhost -p"$mysqlPassword" "$mysqlDataBase" bible_zh_s bible_zh_s_html bible_zh_s_verses | gzip -9 > bible_zh_s_all.sql.gz

# Traditional Chinese has no morphology table.
mysqldump --add-locks=false --lock-tables=false -u "$mysqlUserName" -h localhost -p"$mysqlPassword" "$mysqlDataBase" bible_zh_t bible_zh_t_html bible_zh_t_verses | gzip -9 > bible_zh_t_all.sql.gz

mysqldump --add-locks=false --lock-tables=false -u "$mysqlUserName" -h localhost -p"$mysqlPassword" "$mysqlDataBase" book_english | gzip -9 > extra/book_english.sql.gz

mysqldump --add-locks=false --lock-tables=false -u "$mysqlUserName" -h localhost -p"$mysqlPassword" "$mysqlDataBase" paragraphs | gzip -9 > extra/paragraphs.sql.gz

# Beep to indicate completion.
echo $'\a'
