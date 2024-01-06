#!/usr/bin/env ruby

require 'base64'
require 'ech_config'

def pem_to_base64(pem)
  pem.gsub(/-----(BEGIN|END) ECH CONFIGS-----/, '').gsub("\n", '')
end

def parse_echconfigs(bin)
  raise 'failed to parse ECHConfigs' \
    unless bin.length == bin.slice(0, 2).unpack1('n') + 2

  begin
    echconfigs = ::ECHConfig.decode_vectors(bin.slice(2..))
  rescue ::ECHConfig::Error
    raise 'failed to parse ECHConfigs'
  end

  echconfigs
end

if ARGV.empty?
  warn 'error: not specified filename with ARGV'
  exit 1
end

pem = File.open(ARGV[0]).read
puts pem
puts ''
encoded = pem_to_base64(pem)
puts '---------- base64 ----------'
puts encoded
bin = Base64.decode64(encoded)
echconfigs = parse_echconfigs(bin)
puts '----------- fields -----------'
# https://www.ietf.org/archive/id/draft-ietf-tls-esni-15.html#section-4-2
echconfigs.each do |c|
  puts 'ECHConfig:'
  puts "  version(uint16):\t\t\t#{c.version.unpack1('H4').scan(/.{2}/).join(' ')}"
  echconfig_contents = c.echconfig_contents
  puts "  length(uint16):\t\t\t#{echconfig_contents.encode.length}"
  puts '  contents(ECHConfigContents):'
  puts '    key_config(HpkeKeyConfig):'
  key_config = echconfig_contents.key_config
  puts "      config_id(uint8):\t\t\t#{key_config.config_id}"
  puts "      kem_id(uint16):\t\t\t#{key_config.kem_id.encode.unpack1('H4').scan(/.{2}/).join(' ')}"
  puts "      public_key(opaque):\t\t#{key_config.public_key.opaque.unpack1('H*').scan(/.{2}/).join(' ')}"
  puts '      cipher_suites(HpkeSymmetricCipherSuite):'
  key_config.cipher_suites.each do |cs|
    puts "        kdf_id(uint16):\t\t\t#{cs.kdf_id.encode.unpack1('H4').scan(/.{2}/).join(' ')}"
    puts "        aead_id(uint16):\t\t#{cs.aead_id.encode.unpack1('H4').scan(/.{2}/).join(' ')}"
  end
  puts "    maximum_name_length(uint8):\t\t#{echconfig_contents.maximum_name_length}"
  puts "    public_name(opaque):\t\t#{echconfig_contents.public_name}"
  puts "    extensions(opaque):\t\t\t#{echconfig_contents.extensions.octet.unpack1('H*').scan(/.{2}/).join(' ')}"
end
