#!/bin/bash

# get CPU-Core count
cores="`cat /proc/cpuinfo | /bin/grep processor | /usr/bin/wc -l`"

# shift ISRs to other CPU-core if 4 cores (0-3) are available
if [ ${cores} -eq 4 ]
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

while [ true ]
do
	/bin/sleep 10
	# use "sync" to get free buffers
	/bin/cat /proc/buddyinfo | awk '{ if( ($(NF-1)+(($NF)*2)) < 2 ){printf("%s-%s:\t", $3,$4); print("sync"); system("/bin/sync");} }'
	/bin/sleep 10
	# drop caches to collect unused buffers
	/bin/cat /proc/buddyinfo | awk '{ if( ($(NF-1)+(($NF)*2)) < 8 ){printf("%s-%s:\t", $3,$4); print("drop_caches"); system("/bin/echo 3 > /proc/sys/vm/drop_caches");} }'
	/bin/sleep 10
	# compact memory to get more big continuous free memory  
	/bin/cat /proc/buddyinfo | awk '{ if( ($(NF-1)+(($NF)*2)) < 8 ){printf("%s-%s:\t", $3,$4); print("compact_memory"); system("/bin/echo 1 >/proc/sys/vm/compact_memory");} }'
done

