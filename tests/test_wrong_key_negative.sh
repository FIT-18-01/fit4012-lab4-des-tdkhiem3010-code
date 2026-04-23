#!/usr/bin/env bash
set -euo pipefail

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"
WRONG_KEY="1111001100110100010101110111100110011011101111001101111111110001"

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des

ENC_OUTPUT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des 2>&1)
CIPHERTEXT=$(printf '%s\n' "$ENC_OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ -z "$CIPHERTEXT" ]]; then
  echo "[FAIL] Không lấy được ciphertext để test wrong key"
  exit 1
fi

DEC_OUTPUT=$(printf "2\n%s\n%s\n" "$CIPHERTEXT" "$WRONG_KEY" | ./des 2>&1)
DECRYPTED=$(printf '%s\n' "$DEC_OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ -z "$DECRYPTED" ]]; then
  echo "[FAIL] Không lấy được plaintext khi decrypt với wrong key"
  exit 1
fi

if [[ "$DECRYPTED" == "$PLAINTEXT" ]]; then
  echo "[FAIL] Wrong key negative test failed: giải mã sai key nhưng vẫn ra plaintext gốc"
  exit 1
fi

echo "[PASS] Wrong key negative: decrypt với incorrect key không khôi phục đúng plaintext"
