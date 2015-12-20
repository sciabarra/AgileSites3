#!/bin/bash
while ! nc shared.loc 1521 </dev/null
do sleep 1
done
sleep 5
bash rcu.sh
bash config.sh
