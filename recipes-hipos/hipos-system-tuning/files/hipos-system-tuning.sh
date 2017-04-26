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

wait_sec=0;

while true
do
	/bin/sleep $((wait_sec))
	buffers_count="$(awk '{ print ($(NF-2)+($(NF-1)*2)+(($NF)*4)) }' < /proc/buddyinfo | head -n 1)";
	wait_sec=$((buffers_count/8))

	# use "sync" to get free buffers
	if [ ${buffers_count} -le 8  ]; then
		/bin/echo "DMA: sync";
		/bin/sync;
	fi
	if [ ${buffers_count} -le 64 ]; then
		# drop caches to collect unused slab objects and pagecache buffers
		/bin/echo 3 > /proc/sys/vm/drop_caches;
	elif [ ${buffers_count} -le 96 ]; then
		# drop caches to collect pagecache buffers
                /bin/echo 1 > /proc/sys/vm/drop_caches;
        fi
	if [ ${buffers_count} -le 16 ]; then
                # compact memory to get more big continuous free memory
                /bin/echo "DMA: compact_memory";
		/bin/echo 1 >/proc/sys/vm/compact_memory;
        fi
done
