#!/bin/bash

port=4444

if [ -z "$port" ]; then
    echo "Port not specified. Exiting...";
    exit 1;
elif [ $port -lt 0 ] || [ $port -gt 65535 ]; then
    echo "Invalid port. Exiting...";
    exit 1;
else
    echo "Port $port selected.";
fi

if [ $UID -ne 0 ]; then
    echo "You must be root to run this script.";
    printf "Authenticate as root: "; 
    sudo su <<EOF
    echo "Starting port monitoring..."

EOF
else
    echo "You are root.";
    echo "Starting port monitoring...";
fi

sudo su <<EOF
    iptables -A INPUT -p tcp --destination-port $port -j LOG --log-prefix "Acesso à porta 4444"
EOF
echo "Port monitoring started."

tail -f /var/log/kern.log | grep "Acesso à porta $port" >> /home/guizinpote/.log/complete_port_monitoring.log  

tail -f /var/log/kern.log | grep "Acesso à porta $port" | while read -r line; do
    echo "Port $port accessed at $(date +%d-%m-%Y_%H:%M:%S)" >> /home/guizinpote/.log/resume_port_monitoring.log
done


