# pem_to_echconfigs

`pem_to_echconfigs` parses ECHConfigs PEM file and print results.

You can run test it the following:

```sh-session
$ gem install bundler

$ bundle install

$ bundle exec pem_to_echconfigs.rb /path/to/pem/file
```

For example:

```sh-session
$ bundle exec ruby pem_to_echconfigs.rb echconfigs.pem
-----BEGIN ECH CONFIGS-----
AEb+DQBCGwAgACDSupslkfIkg/C0be/yDdZqtUJs4ssKG5IgWHadWXn4KQAEAAEA
ASUTY2xvdWRmbGFyZS1lc25pLmNvbQAA
-----END ECH CONFIGS-----

---------- base64 ----------
AEb+DQBCGwAgACDSupslkfIkg/C0be/yDdZqtUJs4ssKG5IgWHadWXn4KQAEAAEAASUTY2xvdWRmbGFyZS1lc25pLmNvbQAA
----------- fields -----------
ECHConfig:
  version(uint16):			fe 0d
  length(uint16):			66
  contents(ECHConfigContents):
    key_config(HpkeKeyConfig):
      config_id(uint8):			27
      kem_id(uint16):			00 20
      public_key(opaque):		d2 ba 9b 25 91 f2 24 83 f0 b4 6d ef f2 0d d6 6a b5 42 6c e2 cb 0a 1b 92 20 58 76 9d 59 79 f8 29
      cipher_suites(HpkeSymmetricCipherSuite):
        kdf_id(uint16):			00 01
        aead_id(uint16):		00 01
    maximum_name_length(uint8):		37
    public_name(opaque):		cloudflare-esni.com
    extensions(opaque):
```
