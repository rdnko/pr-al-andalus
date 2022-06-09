#!/bin/bash/

sed "s/direccion_local/$(hostname -I | cut -f1 -d' ')/g" index.html > /var/www/html/index.html
