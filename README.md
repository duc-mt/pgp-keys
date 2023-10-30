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

Archive the private keys

```shell
tar zcvf private-keys.tgz privkey.asc
```

Encrypt the private-keys.tgz archive with a 'master' password

```shell
openssl aes-256-cbc -salt -pbkdf2 -in private-keys.tgz -out private-keys.tgz.enc
```

`private-keys.tgz.enc` can be made publicly available, as it is encrypted with
the master supplied password.

# Restore the PGP Keys

```shell
wget -P ~/.pgp https://github.com/tanducmai/pgp-keys/raw/master/doc/private-keys.tgz.enc && openssl aes-256-cbc -salt -pbkdf2 -in ~/.pgp/private-keys.tgz.enc -out ~/.pgp/private-keys.tgz -d && tar zxvf ~/.pgp/private-keys.tgz -C ~/.pgp && rm ~/.pgp/private-keys.tgz*
```

# Import Your Keypair

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
