#!/bin/bash

# get CPU-Core count
cores="$(/bin/grep processor /proc/cpuinfo | /usr/bin/wc -l)"

# shift ISRs to other CPU-core if 4 cores (0-3) are available
if [ "${cores}" -eq 4 ]
	then
		/bin/echo "reconfigure: smp_affinity"
		# ethernet to core 3
		interrupts="`/usr/bin/find /proc/irq/ | grep -i ethernet | /usr/bin/awk 'BEGIN { FS = \"/\" } ; { print \$4 }'`"
		for i in ${interrupts}; do
		        /bin/echo 8 >/proc/irq/$i/smp_affinity
		done

		# IPU and VPU to core 2
		interrupts="`/usr/bin/find /proc/irq/ | grep -i ipu | /usr/bin/awk 'BEGIN { FS = \"/\" } ; { print \$4 }'`"
		for i in ${interrupts}; do
		        /bin/echo 4 >/proc/irq/$i/smp_affinity
		done		
		interrupts="`/usr/bin/find /proc/irq/ | grep -i vpu | /usr/bin/awk 'BEGIN { FS = \"/\" } ; { print \$4 }'`"
		for i in ${interrupts}; do
		        /bin/echo 4 >/proc/irq/$i/smp_affinity
		done

		# PCIe and SATA to core 1
		interrupts="`/usr/bin/find /proc/irq/ | grep -i pcie | /usr/bin/awk 'BEGIN { FS = \"/\" } ; { print \$4 }'`"
		for i in ${interrupts}; do
		        /bin/echo 2 >/proc/irq/$i/smp_affinity
		done
		interrupts="`/usr/bin/find /proc/irq/ | grep -i sata | /usr/bin/awk 'BEGIN { FS = \"/\" } ; { print \$4 }'`"
		for i in ${interrupts}; do
		        /bin/echo 2 >/proc/irq/$i/smp_affinity
		done
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
