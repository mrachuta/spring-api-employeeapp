#!/bin/bash

JAVA_HOME='/usr/lib/jvm/java-17-openjdk-amd64'
WORKDIR='/opt/employeeapp/'
JAVA_OPTIONS='-Xms256m -Xmx1024m -server'
APP_OPTIONS='--spring.config.location=file:./application-gcp.properties'

cd $WORKDIR || exit 1
"${JAVA_HOME}/bin/java" $JAVA_OPTIONS -jar employeeapp.war $APP_OPTIONS
