require 'rails_helper'
require 'base64'

RSpec.describe Ciphers::SuperEncryptionCipher do
  let(:cipher_alg) { described_class.new }

  describe '#encrypt_data and #decrypt_data' do
    [
      { key: '%!&01#', plaintext: 'B$%E$!%#A123##34712BFCIE138A9AWE3421', cipher_text: 'gJHWV|EDDcTfKgYl^YuadsqdUchzjcDVThdT' }
    ].each do |test_case|
      context "with key '#{test_case[:key]}'" do
        it 'correctly encrypts and decrypts' do
          encrypted = cipher_alg.encrypt_data(test_case[:plaintext], test_case[:key])
          expect(Base64.encode64(encrypted)).to eq(Base64.encode64(test_case[:cipher_text]))
          decrypted = cipher_alg.decrypt_data(encrypted, test_case[:key])
          expect(Base64.encode64(decrypted)).to eq(Base64.encode64(test_case[:plaintext]))
        end
      end
    end
  end
end
