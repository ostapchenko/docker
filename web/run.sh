#!/bin/bash

# add vithosts to hosts:
for vhostFile in /etc/apache2/sites-enabled/*.conf
do
    vhostName=${vhostFile##*/}
    vhost=${vhostName%.*}
    echo "127.0.0.1 ${vhost}" >> /etc/hosts
done

# container execution command:
bash -c "source /etc/apache2/envvars && apache2 -DFOREGROUND"
