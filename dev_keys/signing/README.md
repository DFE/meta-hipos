# Signing Keys

## roothash.salt

Used to salt dm-verity generation. Create with:

```
$ openssl rand -hex 32 > roothash.salt
# or
$ head -c32 /dev/urandom | xxd -ps -c 0 > roothash.salt
```

## roothash key pair

Private key is used to sign the roothash in Yocto, public key is used to validate roothash when firmware boots. Create with:

```
# To Generate Private Key
$ openssl ecparam -name secp521r1 -genkey -noout -out roothash-private-key.pem

# To Generate The Public Key
$ openssl ec -in roothash-private-key.pem -pubout -out roothash-public-key.pem
```