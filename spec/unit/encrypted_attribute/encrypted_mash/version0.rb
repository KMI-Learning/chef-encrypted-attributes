#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe Chef::EncryptedAttribute::EncryptedMash::Version0 do
  before(:all) do
    @key1 = OpenSSL::PKey::RSA.new(256)
    @key2 = OpenSSL::PKey::RSA.new(256)
    @EncryptedMash = Chef::EncryptedAttribute::EncryptedMash
    @EncryptedMashVersion0 = Chef::EncryptedAttribute::EncryptedMash::Version0
  end

  context '#new' do

    it 'should create an EncryptedMash::Version0 object without errors' do
      expect { @EncryptedMashVersion0.new }.not_to raise_error
    end

    it 'should set the CHEF_TYPE key' do
      o = @EncryptedMashVersion0.new
      expect(o[@EncryptedMash::CHEF_TYPE]).to eql(@EncryptedMash::CHEF_TYPE_VALUE)
    end

    it 'should set the JSON_CLASS key' do
      o = @EncryptedMashVersion0.new
      expect(o[@EncryptedMash::JSON_CLASS]).to eql(@EncryptedMashVersion0.to_s)
    end

  end # context #new

  context '#encrypt and #can_be_decrypted_by?' do

    it 'should encrypt a value passing a OpenSSL::PKey::RSA key' do
      body = @EncryptedMashVersion0.new
      expect(body.can_be_decrypted_by?(@key1)).to eql(false)
      body.encrypt('value1', @key1.public_key)
      expect(body.can_be_decrypted_by?(@key1)).to eql(true)
    end

    it 'should encrypt a value passing a Ruby 1.9.2 OpenSSL::PKey::RSA key' do
      private_key = [
        '-----BEGIN RSA PRIVATE KEY-----',
        'MIIEpAIBAAKCAQEA5DXvCHjiXlee7SR69w88TQxc+XS7THnNCn2D9vXS8c0XARoE',
        'OtBF84BtlzF7mIdS/P4CltFYB/Jmg4nTiGwmGZETZ6IeA+OBtLAKKAqyYJCq5UwM',
        'rm/3dZ4GFUVGKeMNGp7j3xummUFljM6pxjTbF+MsKA41YAzkl2g8sHTnDUaudwIQ',
        'GNufo3/ZL5qyksPALkzTHvpkIdq75mRB99a4HU47iUfAnrKwOBtvYb43/2auTv6j',
        'GRMvRNnBPpO2GXlk1mlzOg1rJP2f0DFQNq/G0HwtMOWn4TbJ6pz1ZxxYHrU44eJJ',
        'ULH9NPFHGOSQQKK8UdQKWZtjW375Mqo5viogmQIDAQABAoIBAQCt2cB9Tcn1YP67',
        'XZ0ndT3U3GQ/zYOaIPfo0/GiQ2ctubWaqz0pqNyBQgc6tQGZEw5PmRpT1qsfcrRR',
        '5L93IBxuQazst/3xrHF1Ot6h3nRBSDRIdgT7JmT3/yhXL+zhoAytiPnDT4c9HSrF',
        'd/KyAjYeHnvXD+vtfiTuiwQg0Q3rd8qlDq09smjYiRAYIxxxnXHkS5cUoDA4rv5A',
        'RVbeBsGlo+DUvZ6M7ARQiUB08nOJl/HAYDhbxSKo1m7V8cHnd7ZdTlTgvfj20+YU',
        'aS8hMA54Fgg27Cig1X/qcOASogKbYOlprIJoose0+2CQNZkA0qUKy7ExWIact85w',
        'QanJpeYBAoGBAPkgc/sbV0tjTtqLo2+yAV26VtTaVozh+TtVmzaK6Y2xxvb/RsgB',
        'fKBmyUDphowaHLQkPiX7uRiuu4S033IyeOufEEaaM0PJreBl94g+ZZaf4L7VhVDu',
        'z8BpIfSY/syfbIix7KDgfDF/W5usx8ZQ7VYSZfw22SX/ptVHwC5lRQrhAoGBAOqB',
        'wNf1tupE1mMQM/1K+QbVpOYDdjtQqZDQRFjYV1GXwEtbCGOnpeX+hI9j6FW93ugA',
        '4VJxYqtrgJM2dbg9thqTgg+ORTrEAJAV8TKE7vhexf0QJxZYLJlqwD5UFrAm/+SW',
        'mqSQ9YZYMghbWsuwFlegc0uxOaF0A3umfb06EcS5AoGBAOm2YlgOfESDM7SfD4J3',
        'sgRmDZO+CTg9vnzFgMkYZKbDQu7w6Uw06N/pzaAR9GF3FbqBzbQAhNL9CXoj3QPb',
        'Ccmx/ajefH15tJ8xyZiNQOyfrE4bLeiRQWE2v94hsdfxL/bFREJgluIwopZW70vD',
        'HASFWhvUsL6PKcood8iOxMjBAoGAPgoZtIiC3bNcbFTLDEWbYB2BRIDB9KtAUNlo',
        'W4DQiPt2mfj5XTPrBc+xziWGP7i9ke85rQ/mJKeKGmgb+KQK2zkO/YKL+iIEbBoB',
        '93WHqxmXk32EebrWAbhmJ5cjcXK/2/+j5cmbyvDmO6O/f4eUQZZnKi02q+n/SeUf',
        '+sG0FbECgYAv6SzofP+PbHDhEPZT56nhhsY+SyDyy5fFUFPwNnQZdvCI4KO/x8mf',
        'j21MQ1vW8XRPZeKH9tfgIPFiWrhuonqwuOdALBj5oOGWxs6DqM0oPiWwEcYGVJOd',
        '4G2eOZs4QHAlWHvxQqZmBvJdzBzsbNw1rD+hJVLxcMyOsS15rY/Bxw==',
        '-----END RSA PRIVATE KEY-----',
      ]
      public_key_ruby192 = [
        '-----BEGIN RSA PUBLIC KEY-----',
        'MIIBCgKCAQEA5DXvCHjiXlee7SR69w88TQxc+XS7THnNCn2D9vXS8c0XARoEOtBF',
        '84BtlzF7mIdS/P4CltFYB/Jmg4nTiGwmGZETZ6IeA+OBtLAKKAqyYJCq5UwMrm/3',
        'dZ4GFUVGKeMNGp7j3xummUFljM6pxjTbF+MsKA41YAzkl2g8sHTnDUaudwIQGNuf',
        'o3/ZL5qyksPALkzTHvpkIdq75mRB99a4HU47iUfAnrKwOBtvYb43/2auTv6jGRMv',
        'RNnBPpO2GXlk1mlzOg1rJP2f0DFQNq/G0HwtMOWn4TbJ6pz1ZxxYHrU44eJJULH9',
        'NPFHGOSQQKK8UdQKWZtjW375Mqo5viogmQIDAQAB',
        '-----END RSA PUBLIC KEY-----',
      ]
      public_key_ruby2 = [
        '-----BEGIN PUBLIC KEY-----',
        'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5DXvCHjiXlee7SR69w88',
        'TQxc+XS7THnNCn2D9vXS8c0XARoEOtBF84BtlzF7mIdS/P4CltFYB/Jmg4nTiGwm',
        'GZETZ6IeA+OBtLAKKAqyYJCq5UwMrm/3dZ4GFUVGKeMNGp7j3xummUFljM6pxjTb',
        'F+MsKA41YAzkl2g8sHTnDUaudwIQGNufo3/ZL5qyksPALkzTHvpkIdq75mRB99a4',
        'HU47iUfAnrKwOBtvYb43/2auTv6jGRMvRNnBPpO2GXlk1mlzOg1rJP2f0DFQNq/G',
        '0HwtMOWn4TbJ6pz1ZxxYHrU44eJJULH9NPFHGOSQQKK8UdQKWZtjW375Mqo5viog',
        'mQIDAQAB',
        '-----END PUBLIC KEY-----',
      ]
      stub_const('RUBY_VERSION', '1.9.2')
      key = OpenSSL::PKey::RSA.new(private_key.join("\n"))
      body = @EncryptedMashVersion0.new
      expect(body.can_be_decrypted_by?(key)).to eql(false)
      body.encrypt('value1', public_key_ruby2.join("\n"))
      expect(body.can_be_decrypted_by?(public_key_ruby192.join("\n"))).to eql(true)
    end

    it 'should encrypt a value passing a PEM String key' do
      body = @EncryptedMashVersion0.new
      expect(body.can_be_decrypted_by?(@key1)).to eql(false)
      body.encrypt('value1', @key1.public_key.to_pem)
      expect(body.can_be_decrypted_by?(@key1)).to eql(true)
    end

    it 'should encrypt a value passing a OpenSSL::PKey::RSA array' do
      keys = [ @key1, @key2 ]
      body = @EncryptedMashVersion0.new
      expect(body.can_be_decrypted_by?(keys)).to eql(false)
      body.encrypt('value1', keys.map { |k| k.public_key })
      expect(body.can_be_decrypted_by?(keys)).to eql(true)
    end

    it 'should encrypt a value passing a Strings array' do
      keys = [ @key1, @key2 ]
      body = @EncryptedMashVersion0.new
      expect(body.can_be_decrypted_by?(keys)).to eql(false)
      body.encrypt('value1', keys.map { |k| k.public_key.to_pem })
      expect(body.can_be_decrypted_by?(keys)).to eql(true)
    end

    it 'should throw an InvalidPrivateKey error if the key is invalid' do
      body = @EncryptedMashVersion0.new
      expect { body.encrypt('value1', 'invalid-key') }.to raise_error(Chef::EncryptedAttribute::InvalidPrivateKey, /The provided key is invalid:/)
    end

    it 'should throw an InvalidPrivateKey error if the public key is missing' do
      allow_any_instance_of(OpenSSL::PKey::RSA).to receive(:public?).and_return(false)
      body = @EncryptedMashVersion0.new
      expect { body.encrypt('value1', @key1.public_key) }.to raise_error(Chef::EncryptedAttribute::InvalidPublicKey)
    end

    it 'should throw an error if there is an RSA Error' do
      key = OpenSSL::PKey::RSA.new(32) # will raise "OpenSSL::PKey::RSAError: data too large for key size" on encryption
      body = @EncryptedMashVersion0.new
      expect { body.encrypt('value1', key) }.to raise_error(Chef::EncryptedAttribute::EncryptionFailure)
    end

  end # context #encrypt and #can_be_decrypted_by?

  context '#decrypt' do

    [
      true, false, 0, 'value1', [], {}
    ].each do |v|
      it "should decrypt an encrypted #{v}" do
        body = @EncryptedMashVersion0.new
        body.encrypt(v, @key1.public_key)
        expect(body.decrypt(@key1)).to eql(v)
      end
    end

    it 'should throw an InvalidPrivateKey error if the private key is invalid' do
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', @key1.public_key)
      expect { body.decrypt('invalid-private-key') }.to raise_error(Chef::EncryptedAttribute::InvalidPrivateKey, /The provided key is invalid:/)
    end

    it 'should throw an InvalidPrivateKey error if only the public key is provided' do
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', @key1.public_key)
      expect { body.decrypt(@key1.public_key) }.to raise_error(Chef::EncryptedAttribute::InvalidPrivateKey, /The provided key for decryption is invalid, a valid public and private key is required\./)
    end

    it 'should throw a DecryptionFailure error if the private key cannot decrypt it' do
      bad_key = @key2
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', @key1.public_key)
      expect { body.decrypt(bad_key) }.to raise_error(Chef::EncryptedAttribute::DecryptionFailure, /Attribute data cannot be decrypted by the provided key\./)
    end

    it 'should throw a DecryptionFailure error if the data is corrupted and cannot be decrypted' do
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', @key1.public_key)
      body['encrypted_data'] = Hash[body['encrypted_data'].map do |k, v|
        [ k, 'Corrupted data' ]
      end]
      expect { body.decrypt(@key1) }.to raise_error(Chef::EncryptedAttribute::DecryptionFailure, /OpenSSL::PKey::RSAError/)
    end

    it 'should throw a DecryptionFailure error if the embedded JSON is corrupted' do
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', @key1.public_key)
      body['encrypted_data'] = Hash[body['encrypted_data'].map do |k, v|
        [ k, Base64.encode64(@key1.public_encrypt('bad-json')) ]
      end]
      expect { body.decrypt(@key1) }.to raise_error(Chef::EncryptedAttribute::DecryptionFailure, /Yajl::ParseError/)
    end

  end # context #decrypt

  context '#needs_update?' do

    it 'should return false if there no new keys' do
      keys = [ @key1.public_key ]
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', keys)
      expect(body.needs_update?(keys)).to be_false
    end

    it 'should return true if there are new keys' do
      keys = [ @key1.public_key ]
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', keys)
      keys.push(@key2.public_key)
      expect(body.needs_update?(keys)).to be_true
    end

    it 'should return true if some keys are removed' do
      keys = [ @key1.public_key, @key2.public_key ]
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', keys)
      expect(body.needs_update?(keys[0])).to be_true
    end

    it 'should return false if the keys are the same, but in different order or format' do
      keys = [ @key1.public_key, @key2.public_key ]
      body = @EncryptedMashVersion0.new
      body.encrypt('value1', keys)
      expect(body.needs_update?([ keys[1], keys[0].to_pem ])).to be_false
    end

  end # context #needs_update?

end # describe Chef::EncryptedAttribute::EncryptedMash::Version0
