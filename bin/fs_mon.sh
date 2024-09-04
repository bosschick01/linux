#!/bin/bash
#
# 파일이름: fs_mon.sh
# 제작자: song
# 제작일: 2024.07.31
#

# FS 변수는 모니터링 대상이 되는 파일시스템이다.
# MAILON 변수는 같은 날짜에 한번만 메일을 보내도록 하기 위한 날짜를 담는 변수이다.
# MAILCONTENT 변수는 "df -h" 명령어의 출력 결과를 담을 임시 파일 이름(메일 내용이 됨)이다.
FS='/raid0'
MAILON=$(date +%m%d)
MAILCONTENT=/tmp/tmp1

# 5초에 한번씩 점검 작업을 합니다. sleep time 조정해야 사용한다.
while true
do
    # 현재 모니터링 대상 파일시스템을 % 사용량을 FS_USAGE 변수에 담는다.
    FS_USAGE=$(/bin/df $FS | tail -1 | awk '{print $5}' | awk -F% '{print $1}')
    # 만약 % 사용량이 80% 이상이면 메일을 관리자에게 경고 메일을 보내 줍니다.
    if [ $FS_USAGE -gt 80 ] ; then
        echo "[ WARN ] $FS capacity is greater than 80%."
        df -h > $MAILCONTENT
        # 같은 날짜에는 다시 메일을 보내지 않도록 하기 위해서 MAILON 변수를 사용한다.
        if [ $MAILON = $(date +%m%d) ] ; then
            mail -s '[CHECK] FS Capacity check' root < $MAILCONTENT
            MAILON=$(date -d '+1 days' +%m%d)
        fi
    else
        echo "[  OK  ] $FS capacity is smaller than 80%."
    fi
    sleep 5
done
