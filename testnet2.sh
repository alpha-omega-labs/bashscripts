#!/bin/bash
cat << "EOF"

	  /$$$$$$                                          /$$                 /$$         /$$
	 /$$__  $$                                        |__/                | $$       /$$$$
	| $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$      | $$      |_  $$
	| $$ /$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/      | $$        | $$	
	| $$|_  $$| $$$$$$$$| $$  \ $$| $$$$$$$$|  $$$$$$ | $$|  $$$$$$       | $$        | $$
	| $$  \ $$| $$_____/| $$  | $$| $$_____/ \____  $$| $$ \____  $$      | $$        | $$
	|  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/| $$ /$$$$$$$/      | $$$$$$$$ /$$$$$$
	 \______/  \_______/|__/  |__/ \_______/|_______/ |__/|_______/       |________/|______/

	Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!

	This script will setup and run your Genesis L1 testnetv2 node based on evmos v 0.1.3 binary.

  EVM chain ID: 1000
  Coin unit: L1
  Min. coin unit: aphoton
  Min. gas price: 1 aphoton
  1 L1 = 1 000 000 000 000 000 000 aphoton 	
  Initial supply: 21 000 000 L1
  Mint rate: < 20% annual
  
EOF
sleep 10s
sudo apt-get update -y
sudo apt-get install jq git wget make gcc build-essential snapd -y
snap install --channel=1.17/stable go --classic
export PATH=$PATH:$(go env GOPATH)/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
cd .
wget https://github.com/tharsis/evmos/releases/download/v0.1.3/evmos_0.1.3_Linux_x86_64.tar.gz
tar -xf evmos_0.1.3_Linux_x86_64.tar.gz
cd bin
./evmosd version
sleep 5s
./evmosd config keyring-backend test
./evmosd config chain-id genesis_1000-1
./evmosd keys add $1 --keyring-backend test --algo eth_secp256k1
./evmosd init $2 --chain-id genesis_1000-1
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="100000000"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json

./evmosd add-genesis-account $1 21000000000000000000000000aphoton --keyring-backend test
./evmosd gentx $1 1000000000000000000aphoton --keyring-backend test --chain-id genesis_1000-1
./evmosd collect-gentxs
./evmosd validate-genesis
echo Starting your Genesis L1 localtestnnet validator! 
sleep 5s
./evmosd start --pruning=nothing --trace --log_level info --minimum-gas-prices=100000000aphoton --json-rpc.api eth,txpool,personal,net,debug,web3,miner &
evmosd=$!
sleep 10s
kill $evmosd_pid
echo Genesis L1 node stopped, adjusting to public testnetV2
sleep 5s
echo Starting some preparations before joining public network: adding peers, seeds, genesis.json and some LOVE!
cd
cd .evmosd/data
find -regextype posix-awk ! -regex './(priv_validator_state.json)' -print0 | xargs -0 rm -rf
cd ../config
sed -i 's/seeds = ""/seeds = "908670694cbf608cc081981f472e7be554e1401e@168.119.138.91:26656"/' config.toml
sed -i 's/persistent_peers = ""/persistent_peers = "908670694cbf608cc081981f472e7be554e1401e@168.119.138.91:26656"/' config.toml
rm -r genesis.json
wget https://raw.githubusercontent.com/alpha-omega-labs/bashscripts/main/testnetv2/genesis.json
echo All set! 
sleep 3s
cd
cat << "EOF"
     	    \\
             \\_
          .---(')
        o( )_-\_
       Node start                                                                                                                                                                                     
EOF
 
sleep 5s
cd bin
./evmosd start --pruning=nothing --trace --log_level info --minimum-gas-prices=100000000aphoton --json-rpc.api eth,txpool,personal,net,debug,web3,miner
