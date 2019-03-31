#!/bin/sh
set -e
mkdir -p /var/db/tang /var/cache/tang
grep -r -q '"sign"' /var/db/tang || /usr/local/libexec/tangd-keygen /var/db/tang
/usr/local/libexec/tangd-update /var/db/tang /var/cache/tang

socat tcp-l:80,reuseaddr,fork exec:"/usr/local/libexec/tangd /var/cache/tang"
