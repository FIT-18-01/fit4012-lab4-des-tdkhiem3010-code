#!/usr/bin/env bash
set -euo pipefail

PLAINTEXT="1010101011110000111100001010101000011111000011110000111100001111"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des

ENC_OUTPUT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des 2>&1)
CIPHERTEXT=$(printf '%s\n' "$ENC_OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ -z "$CIPHERTEXT" ]]; then
  echo "[FAIL] Không lấy được ciphertext ở bước encrypt"
  exit 1
fi

DEC_OUTPUT=$(printf "2\n%s\n%s\n" "$CIPHERTEXT" "$KEY" | ./des 2>&1)
DECRYPTED=$(printf '%s\n' "$DEC_OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ -z "$DECRYPTED" ]]; then
  echo "[FAIL] Không lấy được plaintext ở bước decrypt"
  exit 1
fi

if [[ "$DECRYPTED" != "$PLAINTEXT" ]]; then
  echo "[FAIL] Round-trip mismatch"
  echo "Plaintext : $PLAINTEXT"
  echo "Decrypted : $DECRYPTED"
  exit 1
fi

echo "[PASS] Round-trip DES encrypt/decrypt đúng"
