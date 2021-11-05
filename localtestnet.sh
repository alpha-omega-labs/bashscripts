#!/bin/bash
echo Hello, how do you do?
sleep 4.20s
echo Getin!
sleep 4.20s
sudo apt-get install jq -y
cd .
wget https://github.com/tharsis/evmos/releases/download/v0.1.3/evmos_0.1.3_Linux_x86_64.tar.gz
tar -xf evmos_0.1.3_Linux_x86_64.tar.gz
cd bin
./evmosd version
echo its alive!
sleep 4.20s
./evmosd config keyring-backend test
./evmosd config chain-id genesis_1000-1
./evmosd keys add mygenesiskey --keyring-backend test --algo eth_secp256k1
./evmosd init genesismoniker --chain-id genesis_1000-1
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="aphoton"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
cat $HOME/.evmosd/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="42000000"' > $HOME/.evmosd/config/tmp_genesis.json && mv $HOME/.evmosd/config/tmp_genesis.json $HOME/.evmosd/config/genesis.json
./evmosd add-genesis-account mygenesiskey 21000000000000000000000000aphoton --keyring-backend test
./evmosd gentx mygenesiskey 500000000000000000000000aphoton --keyring-backend test --chain-id genesis_1000-1
./evmosd collect-gentxs
./evmosd validate-genesis
echo Starting your validator node! 
./evmosd start --pruning=nothing --trace --log_level info --minimum-gas-prices=0aphoton --json-rpc.api eth,txpool,personal,net,debug,web3,miner
