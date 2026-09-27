# PGP Keys Backup

[![CI](https://github.com/duc-mt/pgp-keys/actions/workflows/ci.yml/badge.svg)](https://github.com/duc-mt/pgp-keys/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Getting Started](#getting-started)
- [Backup Your PGP Keys](#backup-your-pgp-keys)
- [Restore the PGP Keys](#restore-the-pgp-keys)
- [Import Your Keypair](#import-your-keypair)
- [Encrypt Message with GPG](#encrypt-message-with-gpg)
- [Decrypt Message with GPG](#decrypt-message-with-gpg)
- [Import Another User PGP Key](#import-another-user-pgp-key)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Getting Started

Install `gpg` software and generate a keypair.

```shell
sudo apt install gpg -y
gpg --full-generate-key
```

To list the long form of the PGP keys for which you have both a public and
private key:

```shell
gpg --list-secret-keys --keyid-format=long
```

```text
/home/netadmin/.pgp/pubring.kbx
-------------------------------
sec   4096R/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
uid                          Hubot <hubot@example.com>
ssb   4096R/4BB6D45482678BE3 2016-03-10
```

Back up the keypair and store it in a safe place.

```shell
gpg --export --armor <fingerprint> --output pubkey.asc
gpg --export-secret-keys --armor <fingerprint> --output privkey.asc
```

A fingerprint is either the long form of the PGP key ID (in this example, the
PGP key ID is 3AA5C34371567BD2) or the associated email address
(hubot@example.com).

# Backup Your PGP Keys

You can use the provided `backup.sh` script to automate the export, archive, and encryption of your keys:

```shell
./backup.sh <fingerprint-or-email>
```

This will generate an updated `pubkey.asc` and a new encrypted `private-keys.tgz.enc` which you can then commit to the repository.

# Restore the PGP Keys

If you have cloned this repository locally, you can easily restore your keys using the automated script:

```shell
./restore.sh
```

*(Alternatively, if you are downloading just the encrypted archive remotely without cloning the repo)*:
```shell
wget -P ~/.pgp https://github.com/duc-mt/pgp-keys/raw/refs/heads/master/private-keys.tgz.enc && openssl aes-256-cbc -salt -pbkdf2 -in ~/.pgp/private-keys.tgz.enc -out ~/.pgp/private-keys.tgz -d && tar zxvf ~/.pgp/private-keys.tgz -C ~/.pgp && rm ~/.pgp/private-keys.tgz*
```

# Import Your Keypair

*(Note: The `./restore.sh` script automates these imports for you if you run it locally.)*

```shell
gpg --import pubkey.asc
gpg --allow-secret-key-import --import privkey.asc
```

[Trust](https://www.gnupg.org/gph/en/manual.html#AEN346) them if necessary.

```shell
gpg --edit-key <fingerprint>
```

# Encrypt Message with GPG

```shell
gpg --armor --sign --encrypt --recipient <name> path/to/file
gpg -a -s -e -r <name> path/to/file
```

The output filename will be the same as the input filename, but with `.asc`
extension.

# Decrypt Message with GPG

```shell
gpg --decrypt path/to/file.asc
gpg -d path/to/file.asc
```

# Import Another User PGP Key

```shell
gpg --recv-keys <keyID>
```

or

```shell
gpg --search-keys <name>
```
