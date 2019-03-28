#!/bin/bash

# get CPU-Core count
cores="$(/bin/grep processor /proc/cpuinfo | /usr/bin/wc -l)"

# shift ISRs to other CPU-core
let CPU=0; cd /proc/irq/;
/bin/echo "found: ${cores} CPU Cores"
for IRQ in *; do
	if [ -f /proc/irq/$IRQ/smp_affinity_list ]; then
		/bin/echo "IRQ$IRQ -> CPU$CPU"
		/bin/echo $CPU > /proc/irq/$IRQ/smp_affinity_list
		if [ $? -eq 0 ]; then
			let CPU+=1
			if [ ${CPU} -ge ${cores} ]; then
				let CPU=0;
			fi
		fi
	fi
done

sleep infinity

