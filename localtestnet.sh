#!/bin/bash
echo Hello, how do you do?
sleep 4.20s
echo Getin!
sleep 4.20s
sudo apt-get install jq -y
cd .
wget https://github.com/tharsis/ethermint/releases/download/v0.5.0/ethermint_0.5.0_Linux_x86_64.tar.gz
tar -xf ethermint_0.5.0_Linux_x86_64.tar.gz
cd bin
./ethermintd version
echo its alive, now you have ethermint v0.5.0
sleep 4.20s
./ethermintd config keyring-backend test
./ethermintd config chain-id genesis_9000-1
./ethermintd keys add mygenesiskey --keyring-backend test --algo eth_secp256k1
./ethermintd init genesismoniker --chain-id genesis_9000-1
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="aphoton"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
cat $HOME/.ethermintd/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="10000000"' > $HOME/.ethermintd/config/tmp_genesis.json && mv $HOME/.ethermintd/config/tmp_genesis.json $HOME/.ethermintd/config/genesis.json
./ethermintd add-genesis-account mygenesiskey 100000000000000000000000000aphoton --keyring-backend test
./ethermintd gentx mygenesiskey 1000000000000000000000aphoton --keyring-backend test --chain-id genesis_9000-1
./ethermintd collect-gentxs
./ethermintd validate-genesis
echo Starting your validator node! 
./ethermintd start --pruning=nothing --trace --log_level info --minimum-gas-prices=0aphoton --json-rpc.api eth,txpool,personal,net,debug,web3,miner
