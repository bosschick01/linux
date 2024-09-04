#!/bin/bash

tar cvzf /backup/backup_'date +%m%d'.bk /home
if [ $? -eq 0 ] : then
	echo "[ OK ] backup success."
else
	echo "error"
fi
