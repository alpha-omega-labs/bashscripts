#!/bin/bash
echo Hello, how do you do? Lets set you up for a train ride!                                    
sleep 5s
sudo apt-get update -y
sudo apt-get install sl
sudo apt-get install wget -y
sudo apt-get install snap -y
snap install jq
echo Getin! Welcome on board! Installing your full node @ Genesis L1 testnet!
sleep 5s
sl -l
cd
wget https://github.com/tharsis/ethermint/releases/download/v0.5.0/ethermint_0.5.0_Linux_x86_64.tar.gz
tar -xf ethermint_0.5.0_Linux_x86_64.tar.gz
cd bin
./ethermintd version
echo Its alive, now you have ethermint v0.5.0
sleep 5s
./ethermintd config keyring-backend test
./ethermintd config chain-id genesis_9000-1
./ethermintd keys add mygenesiskey --keyring-backend test --algo eth_secp256k1
./ethermintd init 123node --chain-id genesis_9000-1
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="10000000"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
./ethermintd add-genesis-account mygenesiskey 100000000000000000000000000aphoton --keyring-backend test
./ethermintd gentx mygenesiskey 1000000000000000000000aphoton --keyring-backend test --chain-id genesis_9000-1
./ethermintd collect-gentxs
./ethermintd validate-genesis
echo Starting your node first time in local mode, letting it work 10s, than stopping it! 
./ethermintd start --pruning=nothing --trace --log_level info --minimum-gas-prices=0aphoton --json-rpc.api eth,txpool,personal,net,debug,web3,miner &
ethermintd_pid=$!
kill $ethermintd_pid
echo Node stop for setup!
sleep 5s
echo Starting some preparations before joining public network: adding peers, seeds, genesis.json and some LOVE!
sleep 5s
cd
cd .ethermintd/data
find -regextype posix-awk ! -regex './(priv_validator_state.json)' -print0 | xargs -0 rm -rf
cd ../config
sed -i 's/seeds = ""/seeds = "454237f66ad87be3312115914c67dc6fb60797c7@172.105.91.103:26656"/' config.toml
sed -i 's/persistent_peers = ""/persistent_peers = "454237f66ad87be3312115914c67dc6fb60797c7@172.105.91.103:26656"/' config.toml
rm -r genesis.json
wget https://raw.githubusercontent.com/alpha-omega-labs/bashscripts/main/genesis.json
cd
cd bin
echo All set! 
sleep 5s
sl -l 
echo Ready, steady, GO!!!  
sleep 5s
./ethermintd start --pruning=nothing --trace --log_level info --minimum-gas-prices=0aphoton --json-rpc.api eth,txpool,personal,net,debug,web3,miner
