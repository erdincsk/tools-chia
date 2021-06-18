#!/bin/bash

cd /home/erdinc/chia-blockchain
. ./activate

min_connected_node_count=4
loop_time_in_seconds=60

while true;
do
	chia_not_synced=$(chia show -s | grep "Not Synced" | wc -l)
	chia_connected_node_count=$(chia show -c | grep "FULL_NODE" | wc -l)
	
	echo -e "Chia Not Connected -> " $chia_not_synced
	echo -e "Connected Node Count -> " $chia_connected_node_count
	loop_time_in_seconds=60


	if [ $chia_not_synced -eq 1 ] || [ $chia_connected_node_count -lt $min_connected_node_count ]; # bağlantı sorunu notları devreye alıyoruz.
	then
		echo -e "Sorunlu bağlantı nodeları devreye alıyoruz"
		chia show -a node-or.chia.net:8444
		chia show -a node-eu.chia.net:8444
		chia show -a node-apne.chia.net:8444
		chia show -a node.chia.net:8444
		loop_time_in_seconds=3
	fi

	sleep $loop_time_in_seconds
done
