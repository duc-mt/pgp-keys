#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "Error: Missing fingerprint or email."
    echo "Usage: ./backup.sh <fingerprint-or-email>"
    exit 1
fi

FINGERPRINT=$1

echo "1. Exporting public key..."
gpg --export --armor "$FINGERPRINT" > pubkey.asc

echo "2. Exporting private key..."
gpg --export-secret-keys --armor "$FINGERPRINT" > privkey.asc

echo "3. Archiving private key..."
tar zcvf private-keys.tgz privkey.asc

echo "4. Encrypting archive (you will be prompted for a password)..."
openssl aes-256-cbc -salt -pbkdf2 -in private-keys.tgz -out private-keys.tgz.enc

echo "5. Cleaning up unencrypted private key files..."
rm -f privkey.asc private-keys.tgz

echo "------------------------------------------------------"
echo "✅ Backup complete!"
echo "The following files have been updated and are ready to be committed:"
echo "  - pubkey.asc"
echo "  - private-keys.tgz.enc"
