#!/bin/bash
rsync -a --exclude=".*" /root/ /tmp/backup >>/var/log/syslog 2>>/var/log/syslog
