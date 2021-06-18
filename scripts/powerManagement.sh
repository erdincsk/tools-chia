#!/bin/bash
#to-do
#*1* bildirimler
#nst -> https://github.com/MikeWent/notify-send-telegram

chia_plot_process_id=$(pgrep chia_plot)
chia_plot_process_status=$(ps -o s= -p $chia_plot_process_id)
#S -> running
#T -> STOPPED
battery_status=$(acpi -a | awk '{print $3}')
#'on-line' or 'off-line'
echo -e "Plotting duraklıyor" | ts '[%Y-%m-%d %H:%M:%S]' | nst "$0" --stdin

if [ ! -z $chia_plot_process_id ]
then
	if [ $battery_status == 'on-line' ]
	then
		echo -e "Power: "$battery_status | ts '[%Y-%m-%d %H:%M:%S]' 
		
		if [ $chia_plot_process_status == "T" ]
		then
			echo -e "Elektrik geldi. Plotting devam ediyor" | ts '[%Y-%m-%d %H:%M:%S]' | nst "$0" --stdin
			kill -CONT $chia_plot_process_id
		fi
	else
		echo -e "Power: "$battery_status | ts '[%Y-%m-%d %H:%M:%S]'
		
		if [ $chia_plot_process_status == "S" ]
		then
			echo -e "Elektrik kesintisi. Plotting duraklıyor" | ts '[%Y-%m-%d %H:%M:%S]' | nst "$0" --stdin
			kill -STOP $chia_plot_process_id
		fi
	fi
else
	echo -e "Chia plotter çalışmıyor" | ts '[%Y-%m-%d %H:%M:%S]' | nst "$0" --stdin
fi
