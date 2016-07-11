#!/bin/bash

# get CPU-Core count
cores="$(/bin/grep processor /proc/cpuinfo | /usr/bin/wc -l)"

# shift ISRs to other CPU-core if 4 cores (0-3) are available
if [ "${cores}" -eq 4 ]
	then
		/bin/echo "reconfigure: smp_affinity"
		# network to core 3
		/bin/echo 8 >/proc/irq/150/smp_affinity
		/bin/echo 8 >/proc/irq/151/smp_affinity
		# IPU and VPU to core 2
		/bin/echo 4 >/proc/irq/35/smp_affinity
		/bin/echo 4 >/proc/irq/37/smp_affinity
		/bin/echo 4 >/proc/irq/38/smp_affinity
		/bin/echo 4 >/proc/irq/39/smp_affinity
		/bin/echo 4 >/proc/irq/40/smp_affinity
		/bin/echo 4 >/proc/irq/44/smp_affinity
		# PCIe and SATA to core 1
		/bin/echo 2 >/proc/irq/71/smp_affinity
		/bin/echo 2 >/proc/irq/155/smp_affinity
fi


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
	# drop caches to collect unused buffers
	if [ ${buffers_count} -le 96 ]; then
		/bin/echo "DMA: drop_caches"
		/bin/echo 3 > /proc/sys/vm/drop_caches;
	fi
	# compact memory to get more big continuous free memory
	if [ ${buffers_count} -le 16 ]; then
		/bin/echo "DMA: compact_memory";
		/bin/echo 1 >/proc/sys/vm/compact_memory;
	fi
done
