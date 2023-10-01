#!/bin/bash

set -e

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Define variables
function_id="701baacb2301e2e73e52a3e6ebe8d5fd42b754699b350a4a55a384fa2fa2e199::fastcoin::mint_to"
TEST_COIN=$(aptos config show-profiles --profile default | jq -r ".Result.default.account")

# Define usage function
usage() {
  echo "Usage: $0 [-h] to amount" 1>&2
  echo "Mint coins to a specified address." 1>&2
  echo "" 1>&2
  echo "Positional arguments:" 1>&2
  echo "  to        The address to mint coins to." 1>&2
  echo "  amount    The amount of coins to mint." 1>&2
  echo "" 1>&2
  echo "Optional arguments:" 1>&2
  echo "  -h        Show this help message and exit." 1>&2
  exit 1
}

# Parse command-line options
while getopts ":h" opt; do
  case ${opt} in
    h )
      usage
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Get input arguments
to="$1"
amount="$2"

echo -e "${GREEN}Minting ${amount} coins to ${to} ...${NC}"
aptos move run --assume-yes \
  --function-id "$function_id" \
  --type-args 0x$TEST_COIN::test_coin::TestCoin \
  --args address:"$to" u64:"$amount"
