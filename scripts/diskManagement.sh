#!/bin/bash
#to-do
# 1- bildirimleri oluştur
# 2-log dosyasının büyüklüğünü kontrol et
#wake-up kopyalamasını bu scripte al

min_free_space=115 #gb
start_disk_no=12
end_disk_no=18
free_space_as_gb=0
free_space_as_tb=0
mount_found=0
move_file_extension=plot

temp_disk_move_folder=/home/erdinc/disks/temp_500gb/move_plot

#echo -e "$get_free_space kb"
#echo -e $((get_free_space/(1024*1024*1024))) "tb"

#diskleri uyanık tutmak için minik bir dosya yazılıyor
for ((active_disk_no=1; active_disk_no<=$end_disk_no; active_disk_no++)); # plot taşıma döngüsü
do
	active_disk="/home/erdinc/disks/"$active_disk_no"_8TB"
	/bin/touch $active_disk/.stayawake &> /dev/null	
done

#ploting sonrası hangi diske taşınacak karar veriliyor.
for ((active_disk_no=$start_disk_no; active_disk_no<=$end_disk_no; active_disk_no++)); # plot taşıma döngüsü
do
	active_disk="/home/erdinc/disks/"$active_disk_no"_8TB"
	if mountpoint -q $active_disk #seçilen disk no gerçekten bilgisayara bağlı mı
	then
		get_free_space=$(df --output=avail $active_disk | grep '[0-9]')
		let "free_space_as_gb = $get_free_space/(1024*1024)"
		let "free_space_as_tb = $get_free_space/(1024*1024*1024)"
		
		if [ $free_space_as_gb -gt $min_free_space ] # bu diskte plot için yer var
		then
			mount_found=1 #plot kopyalanacak bir yer bulundu
			echo -e "aktif disk -> " $active_disk " - boş alan : " $free_space_as_gb"-gb - "$free_space_as_tb"-tb" | ts '[%Y-%m-%d %H:%M:%S]'
			#kopyala komutu
			if [ $(ls -al $temp_disk_move_folder | grep $move_file_extension | wc -l) -gt 0 ] 
			then
				if [ $(ps aux | grep mv | grep -v grep | wc -l) -eq 0 ]
				then
					echo -e "Plot taşıma işlemi başladı" | ts '[%Y-%m-%d %H:%M:%S]'
					mv $temp_disk_move_folder/*.$move_file_extension $active_disk/plots
				else
					echo -e "Plot mevcut ancak başka bir taşıma işlemi gerçekleşiyor." | ts '[%Y-%m-%d %H:%M:%S]'
				fi
			fi
			break #diğer diskleri taramana gerek yok. boş yer olan disk bulundu.
		else
			echo -e "bu diskte sadece $free_space_as_gb gb yer var. sıradaki diske bakılıyor -> " $active_disk | ts '[%Y-%m-%d %H:%M:%S]'
		fi
	fi	
done

if [ $mount_found -lt 1 ]
then 
	echo -e "imdat hiç plot kopyalanacak yer yok!" | ts '[%Y-%m-%d %H:%M:%S]'
fi

