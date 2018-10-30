#!/usr/bin/env bash

set -exo pipefail

# Run iniset
/bin/iniset
# Fix permissions:
chown netdata:netdata /usr/share/netdata/web/ -R

# Remove health.d and python.d directories and copy new files:
rm -r /etc/netdata/health.d
rm -r /etc/netdata/python.d
cp -r /netdata/{health,python}.d /etc/netdata/
chown -R netdata:netdata /etc/netdata

echo -n "" > /usr/share/netdata/web/version.txt

# Insert configs from ENV to /etc/netdata/health_alarm_notify.conf
# This ENVs should be start with "ENV_" prifix
# For example: ENV_SEND_SLACK="YES"
env
for EACH_ENV in $(env | grep "^ENV"); do
    NEW_ENV=$(echo ${EACH_ENV} | cut -d"=" -f2-)
    ENV_FILE=$(echo ${NEW_ENV} | cut -d"+" -f1)
    ENV_VAR=$(echo ${NEW_ENV} | cut -d"+" -f2)
    ENV_VAL=$(echo ${NEW_ENV} | cut -d"+" -f3)
    ENV_DEL=$(echo ${NEW_ENV} | cut -d"+" -f4)
    OLD_ENV=$(grep "${ENV_VAR}" ${ENV_FILE} | grep -v "^#")
    OLD_ENV=$(echo "${OLD_ENV}" | head -n 1)
    RETURN_CODE=${?}
    if [[ ${RETURN_CODE} == 0 ]]; then
        OLD_VAL=$(echo "${OLD_ENV}" | cut -d"${ENV_DEL}" -f2 | sed "s/\"//g" | sed "s/\'//g")
        if [[ ${OLD_VAL} != ${ENV_VAL} ]]; then
            if [[ ${ENV_DEL} == "=" ]]; then
                NEW_LINE=$(echo "${ENV_VAR}${ENV_DEL}\"${ENV_VAL}\"")
            elif [[ ${ENV_DEL} == ":" ]]; then
                NEW_LINE=$(echo "${ENV_VAR}${ENV_DEL} \'${ENV_VAL}\'")
            fi
            sed -i -e "s,${OLD_ENV},${NEW_LINE},g" ${ENV_FILE}
        fi
    else
        NEW_LINE=$(echo "${ENV_VAR}${ENV_DEL}\"${ENV_VAL}\"")
        echo "${NEW_LINE}" >> ${ENV_FILE}
    fi
done

if [ "$1" = 'bash' ]; then
    exec /bin/bash
else
    exec /usr/sbin/netdata -D -u netdata -s /host $@
fi

