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
alias start-plot='rm -rf /home/erdinc/disks/temp_1tb/plot-k32*.tmp; cd /home/erdinc/tools-chia/chia-plotter; ./build/chia_plot -n -1 -r 12 -t /home/erdinc/disks/temp_1tb/ -d /home/erdinc/disks/temp_500gb/move_plot/ -c xch1r38p0ngez2ulufejwuwvh9u7azs7fq9kvh00na6wd0rnsmcytdgsr7k4ep -f b89945a2eb2e329a511d1c3be2c0ae440b9f18eced90767d70e905f86275571f2c386a1e3c0d34b6a8bd0bc9a67bd9e0 |& tee -a ~/chia-plotter-log/log.log'
alias chia-start-hpool='cd /home/erdinc/tools-chia/hpool-miner; ./hpool-miner-chia --config config.yaml'

#chia-scripts
alias chia-addnodes='cd ~/chia-blockchain; ./addNodes.sh'


#mounts
alias mount-ws='sudo umount -l /home/erdinc/disks-ws; sudo sshfs -o allow_other,Compression=no,auto_cache,IdentityFile=/home/erdinc/.ssh/id_rsa -p 2284 erdinc@ws.local:/home/erdinc/disks /home/erdinc/disks-ws/'
alias mount-server='sudo umount -l /home/erdinc/disks-server; sudo sshfs -o allow_other,Compression=no,auto_cache,IdentityFile=/home/erdinc/.ssh/id_rsa erdinc@server.local:/home/erdinc/disks /home/erdinc/disks-server/'


