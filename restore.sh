#!/usr/bin/env bash
set -e

if [ ! -f "private-keys.tgz.enc" ]; then
    echo "Error: private-keys.tgz.enc not found in the current directory."
    exit 1
fi

if [ ! -f "pubkey.asc" ]; then
    echo "Error: pubkey.asc not found in the current directory."
    exit 1
fi

echo "1. Decrypting archive (you will be prompted for the master password)..."
openssl aes-256-cbc -salt -pbkdf2 -in private-keys.tgz.enc -out private-keys.tgz -d

echo "2. Extracting private key..."
tar zxvf private-keys.tgz

echo "3. Importing public key..."
gpg --import pubkey.asc

echo "4. Importing private key..."
gpg --allow-secret-key-import --import privkey.asc

echo "5. Cleaning up unencrypted files..."
rm -f privkey.asc private-keys.tgz

echo "------------------------------------------------------"
echo "✅ Restore complete!"
echo "Don't forget to trust your keys by running:"
echo "  gpg --edit-key <fingerprint>"
