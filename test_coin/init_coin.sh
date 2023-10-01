#!/bin/bash

set -e

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Define constants
function_id="701baacb2301e2e73e52a3e6ebe8d5fd42b754699b350a4a55a384fa2fa2e199::fastcoin::init_coin"
name_hex=$(jq -r '.name' config.json | xxd -ps)
symbol_hex=$(jq -r '.symbol' config.json | xxd -ps)
decimals=$(jq -r '.decimals' config.json)
monitor_supply=$(jq -r '.monitor_supply' config.json)

read -p "$(echo -e ${YELLOW}Cleaning up previous aptos account, press Enter to confirm ...${NC})"
rm .aptos/config.yaml || true

echo -e "${GREEN}Creating a coin account ...${NC}"
echo | aptos init --network testnet
TEST_COIN=$(aptos config show-profiles --profile default | jq -r ".Result.default.account")

echo -e "${GREEN}Deploying the coin ...${NC}"
aptos move publish  --assume-yes --named-addresses test_coin=$TEST_COIN

echo -e "${GREEN}Initializing the coin ...${NC}"
aptos move run --assume-yes \
  --function-id "$function_id" \
  --type-args 0x$TEST_COIN::test_coin::TestCoin \
  --args hex:"$name_hex" hex:"$symbol_hex" u8:"$decimals" bool:"$monitor_supply"
