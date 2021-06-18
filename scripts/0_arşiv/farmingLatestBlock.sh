#!/bin/bash

cd ~/chia-blockchain
. ./activate
farming_block_challenge=$(cat ~/.chia/mainnet/log/debug.log | grep eligible | tail -n 1 | awk {'print $11'} | cut -d. -f1)
block_hash=$(chia show -s | cut -d\| -f2 | grep -A1 Hash\:$ | tail -n 1 | sed 's# ##g')
block_info=$(curl --silent --insecure --cert ~/.chia/mainnet/config/ssl/full_node/private_full_node.crt --key ~/.chia/mainnet/config/ssl/full_node/private_full_node.key -d '{"header_hash": "'"${block_hash}"'" }' -H "Content-Type: application/json" -X POST https://localhost:8555/get_block)
block_challenge=$(echo $block_info | jq -r .block.reward_chain_block.challenge_chain_ip_vdf.challenge)
block_height=$(echo $block_info | jq .block.reward_chain_block.height)
farming_latest=$(echo $block_challenge | grep $farming_block_challenge)
if [[ -z $farming_latest ]];then
	echo "Not farming latest block... Something's wrong"
	telegram-notify --text "Not farming to latest block. Something wrong"
else
	echo "Farming block Height $block_height - Hash: $block_hash"
fi
