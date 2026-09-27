#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
KEYS_DIR="$REPO_ROOT/keys"

if [ ! -f "$KEYS_DIR/private-keys.tgz.enc" ]; then
    echo "Error: $KEYS_DIR/private-keys.tgz.enc not found."
    exit 1
fi

if [ ! -f "$KEYS_DIR/pubkey.asc" ]; then
    echo "Error: $KEYS_DIR/pubkey.asc not found."
    exit 1
fi

echo "1. Decrypting archive (you will be prompted for the master password)..."
openssl aes-256-cbc -salt -pbkdf2 -in "$KEYS_DIR/private-keys.tgz.enc" -out "$KEYS_DIR/private-keys.tgz" -d

echo "2. Extracting private key..."
tar -C "$KEYS_DIR" -zxvf "$KEYS_DIR/private-keys.tgz"

echo "3. Importing public key..."
gpg --import "$KEYS_DIR/pubkey.asc"

echo "4. Importing private key..."
gpg --allow-secret-key-import --import "$KEYS_DIR/privkey.asc"

echo "5. Cleaning up unencrypted files..."
rm -f "$KEYS_DIR/privkey.asc" "$KEYS_DIR/private-keys.tgz"

echo "------------------------------------------------------"
echo "✅ Restore complete!"
echo "Don't forget to trust your keys by running:"
echo "  gpg --edit-key <fingerprint>"
