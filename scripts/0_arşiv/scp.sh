#!/bin/bash

max_plots_to_stop_plotman=5 #max plot count in /media/plot
min_plots_to_run_plotman=3
cloud_plot_folder=/media/plot
local_plot_folder=/media/erdinc/live_hdd_ws_2/plots/cloud
plot_file_extension=plot
local_plotman_status_file=/home/erdinc/.config/plotman_status.txt #remote plotmanı durdurduk durdurmadık durumunu local dosyada tut. boktan bir yöntem.
cloud_chia_path=/home/netflixizle2020/chiaset/chia-blockchain
max_active_scp_process=1 #aynı anda kaç indirme işlemi olacak.

compute_zone=europe-west1-b
compute_login=netflixizle2020@ch2
compute_project=alert-ability-313911

loop_time_in_seconds=120

while true;
do
	#sunucuda hazır plotların sayısını öğren
	plot_count=$(gcloud compute ssh "$compute_login" --zone "$compute_zone" --project "$compute_project" --command="ls -al $cloud_plot_folder | grep $plot_file_extension | wc -l")
	is_plotman_suspended=$(cat $local_plotman_status_file) #bu dosyanın varlıgını henüz kontrol etmiyoruz manual oluşturduk. plotmanı durdurduk mu durdurmadık mı
	echo -e $is_plotman_suspended
	
	#önce plotlamanı hallediyoruz. harddisk dolmasın ilk derdimiz.
	if [ $plot_count -gt $max_plots_to_stop_plotman ]; #harddisk doldu artık daha fazla plot üretme. scp'de bir sıkıntı var.
	then
		gcloud compute ssh "$compute_login" --zone "$compute_zone" --project "$compute_project" --command="cd $cloud_chia_path;. ./activate;plotman suspend all"
		#buraya e-posta bildirimi gelmeli.
		echo -e "plotman suspended"
		echo "1" > "$local_plotman_status_file"
	fi

	if [ $plot_count -lt $min_plots_to_run_plotman ] && [ $is_plotman_suspended -eq 1 ]; #harddisk boşaldı, scp yola geldi. plot üretmeye devam
	then
		gcloud compute ssh "$compute_login" --zone "$compute_zone" --project "$compute_project" --command="cd $cloud_chia_path;. ./activate;plotman resume all"
		#buraya e-posta bildirimi gelmeli.
		echo -e "plotman resumed"
		echo "0" > "$local_plotman_status_file"
	fi
	
	#sonra plot download işine giriyoruz.
	if [ $plot_count -gt 0 ]; #plot dosyası cloud'da hazırsa
	then
		echo -e "İndirilmesi gereken $plot_count adet plot mevcut."
		#devan eden indirme işlemi var mı diye kontrol. iki tane indirme aynı anda yapmıyoruz, biri bitince diğeri başlıyor.
		check_scp_in_progress=$(gcloud compute ssh "$compute_login" --zone "$compute_zone" --project "$compute_project" --command="ps aux | grep scp | grep -v grep | wc -l")
		if [ $check_scp_in_progress -lt $max_active_scp_process ]; #hali hazırda bir scp yok ise
		then
			#plot var, indirme yok. sıradaki indirilecek plot belirleniyor.
			plot_to_be_copied=$(gcloud compute ssh "$compute_login" --zone "$compute_zone" --project "$compute_project" --command="ls -atr $cloud_plot_folder | grep $plot_file_extension | head -1")
			echo -e $plot_to_be_copied
			#indirme işlemi başlatılıyor.
			gcloud compute scp --scp-flag "-l 2000000" --zone $compute_zone $compute_login:$cloud_plot_folder"/"$plot_to_be_copied $local_plot_folder
			if [ "$?" -eq "0" ]; #scp işlemi başarıyla bittiyse
			then
				echo -e "scp OK"
				#kopyalanan plotu cloud'dan sil
				gcloud compute ssh "$compute_login" --zone "$compute_zone" --project "$compute_project" --command="rm -rf $cloud_plot_folder'/'$plot_to_be_copied"
			else
			   echo -e "scp failed"
			fi
		else
			echo -e "Devam eden indirme işlemi olduğu için yeni indirme başlatılmıyor."
		fi
	else
		echo -e "İndirilecek hiç plot yok"
	fi
	sleep $loop_time_in_seconds
done
