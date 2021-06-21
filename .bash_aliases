#hardware
alias ssdtemp='sudo echo -e; echo "1tb -> WD SN750"; sudo nvme smart-log /dev/nvme1n1 | grep "temperature*"; echo -e; echo "500gb -> Samsung MZVKW512HMJP-000H1"; sudo nvme smart-log /dev/nvme0n1p1 | grep "Temperature Sensor *"'
alias ssdtemp_1tb='sudo echo -e; echo "1tb -> WD SN750"; sudo nvme smart-log /dev/nvme0n1 | grep "temperature*"'
alias disks-free='df -hl | grep -v -E "100%" | grep -E "disks" | grep -E -v "nvme"'
alias disks-full='df -hl | grep -E "100%" | grep -E "disks" | grep -E -v "nvme"'
alias disks-all='df -hl | grep -E "disks" | grep -E -v "nvme"'

#linux-tools
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

#chia-itself
alias chia-activate='cd ~/chia-blockchain;. ./activate'
alias chia-gui='cd ~/chia-blockchain;. ./activate; cd ~/chia-blockchain/chia-blockchain-gui; npm run electron &'
alias chia-log='tail -f ~/.chia/mainnet/log/debug.log'
alias chia-farm-summary='cd ~/chia-blockchain;. ./activate; chia farm summary'

#chia-tools-plotman
alias chia-plotman-interactive='cd ~/chia-blockchain;. ./activate;plotman interactive'
alias chia-plotman-status='cd ~/chia-blockchain;. ./activate; plotman status'


#chia-tools-info
alias chia-chiadog='cd /home/erdinc/tools-chia/chiadog; ./start.sh; python3 main.py --config config-harvester-1.yaml; python3 main.py --config config-harvester-2.yaml'
alias chia-harvestgraph='cd ~/tools-chia/chiaharvestgraph; ./chiaharvestgraph /home/erdinc/.chia/mainnet/log/'
alias chia-plot-per-day='grep -i "total time" /home/erdinc/.config/plotman/logs/*.log |awk "{sum=sum+$4} {avg=sum/NR} {tday=86400/avg*6*101.366/1024} END {printf "%d K32 plots, avg %0.1f seconds, %0.2f TiB/day \n", NR, avg, tday}"'
alias chia-total-plot-time='tail -f -n +1 ~/chia-plotter-log/log.log | grep "Total plot"'
alias chia-run-plotstatus-app='cd /home/erdinc/tools-chia/Chia-Plot-Status; ./ChiaPlotStatusGUI/bin/Release/net5.0/ChiaPlotStatus'

#chia-tools-production
alias chia-start-plot='rm -rf /home/erdinc/disks/temp_1tb/plot-k32*.tmp; cd /home/erdinc/tools-chia/chia-plotter; ./build/chia_plot -r 12 -t /home/erdinc/disks/temp_500gb/ -d /home/erdinc/disks/11_8TB/plots/ -p 8c6549542878b645ce62436022f216ff309fe597c46641adc3901332931955d2e5a6ef9ac1c1cff52b434fee7b724be5 -f ade177444a099ca9ea5cdf6361ac62b746fffdcb2be1e7c997f389f5f7306d46307be2b1e91fa6d70e8b04b7901b0f30 -n -1 |& tee -a log.log'
alias chia-start-hpool='cd /home/erdinc/tools-chia/hpool-miner; ./hpool-miner-chia --config config.yaml'

#chia-scripts
alias chia-addnodes='cd ~/chia-blockchain; ./addNodes.sh'

#mounts
alias mount-ws='sudo umount -l /home/erdinc/disks-ws; sudo sshfs -o allow_other,Compression=no,auto_cache,IdentityFile=/home/erdinc/.ssh/id_rsa -p 2284 erdinc@ws.local:/home/erdinc/disks /home/erdinc/disks-ws/'
alias mount-server='sudo umount -l /home/erdinc/disks-server; sudo sshfs -o allow_other,Compression=no,auto_cache,IdentityFile=/home/erdinc/.ssh/id_rsa erdinc@server.local:/home/erdinc/disks /home/erdinc/disks-server/'


