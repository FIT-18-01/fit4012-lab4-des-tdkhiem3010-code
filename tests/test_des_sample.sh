#!/usr/bin/env bash
set -euo pipefail

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"
EXPECTED="0111111010111111010001001001001100100011111110101111101011111000"

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des

OUTPUT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des 2>&1)
ACTUAL=$(printf '%s\n' "$OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ -z "$ACTUAL" ]]; then
  echo "[FAIL] Không trích được ciphertext nhị phân từ output"
  exit 1
fi

if [[ "$ACTUAL" != "$EXPECTED" ]]; then
  echo "[FAIL] DES sample mismatch"
  echo "Expected: $EXPECTED"
  echo "Actual  : $ACTUAL"
  exit 1
fi

echo "[PASS] DES sample vector đúng"
