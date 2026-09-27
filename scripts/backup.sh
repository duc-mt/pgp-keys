#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
KEYS_DIR="$REPO_ROOT/keys"

if [ -z "$1" ]; then
    echo "Error: Missing fingerprint or email."
    echo "Usage: $0 <fingerprint-or-email>"
    exit 1
fi

FINGERPRINT=$1
mkdir -p "$KEYS_DIR"

echo "1. Exporting public key..."
gpg --export --armor "$FINGERPRINT" > "$KEYS_DIR/pubkey.asc"

echo "2. Exporting private key..."
gpg --export-secret-keys --armor "$FINGERPRINT" > "$KEYS_DIR/privkey.asc"

echo "3. Archiving private key..."
tar -C "$KEYS_DIR" -zcvf "$KEYS_DIR/private-keys.tgz" privkey.asc

echo "4. Encrypting archive (you will be prompted for a password)..."
openssl aes-256-cbc -salt -pbkdf2 -in "$KEYS_DIR/private-keys.tgz" -out "$KEYS_DIR/private-keys.tgz.enc"

echo "5. Cleaning up unencrypted private key files..."
rm -f "$KEYS_DIR/privkey.asc" "$KEYS_DIR/private-keys.tgz"

echo "------------------------------------------------------"
echo "✅ Backup complete!"
echo "The following files have been updated and are ready to be committed:"
echo "  - keys/pubkey.asc"
echo "  - keys/private-keys.tgz.enc"
