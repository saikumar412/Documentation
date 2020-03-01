#!/bin/bash
cd /var/www
for FILE in *.yaml
do 
  echo "Copying $FILE"
  cp $FILE /var/www-just-yaml
done
