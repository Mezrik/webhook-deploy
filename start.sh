#!/bin/bash

LOG_SEPARATOR="------------------------------------------"
STARTUP_LOG_LOCATION=./logs/startup.log

if [ $(ps -e -o uid | grep $UID | grep node | grep -v grep | wc -l | tr -s "\n") -eq 0 ]
then
        mkdir -p logs
        echo $LOG_SEPARATOR >> ${STARTUP_LOG_LOCATION}
        date +"%m-%d-%Y-%T" >> ${STARTUP_LOG_LOCATION}
        npm run start >> ${STARTUP_LOG_LOCATION} 2>&1
        echo $LOG_SEPARATOR >> ${STARTUP_LOG_LOCATION}
fi