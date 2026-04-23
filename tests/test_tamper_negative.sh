#!/usr/bin/env bash
set -euo pipefail

PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des

ENC_OUTPUT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des 2>&1)
CIPHERTEXT=$(printf '%s\n' "$ENC_OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ -z "$CIPHERTEXT" ]]; then
  echo "[FAIL] Không lấy được ciphertext gốc"
  exit 1
fi

# Tamper / bit flip: lật bit đầu tiên
if [[ "${CIPHERTEXT:0:1}" == "0" ]]; then
  TAMPERED="1${CIPHERTEXT:1}"
else
  TAMPERED="0${CIPHERTEXT:1}"
fi

DEC_OUTPUT=$(printf "2\n%s\n%s\n" "$TAMPERED" "$KEY" | ./des 2>&1)
DECRYPTED=$(printf '%s\n' "$DEC_OUTPUT" | grep -oE '[01]{64,}' | tail -n 1)

if [[ -z "$DECRYPTED" ]]; then
  echo "[FAIL] Không lấy được plaintext sau tamper"
  exit 1
fi

if [[ "$DECRYPTED" == "$PLAINTEXT" ]]; then
  echo "[FAIL] Tamper negative test failed: dữ liệu vẫn khôi phục như cũ"
  exit 1
fi

echo "[PASS] Tamper negative: bit flip làm sai plaintext như kỳ vọng"
