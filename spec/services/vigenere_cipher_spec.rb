require 'rails_helper'

RSpec.describe VigenereCipher do
  let(:cipher_alg) { VigenereCipher.new }

  describe '#encrypt_data and #decrypt_data' do
    [
      { key: 'KEY', plaintext: 'HELLOWORLD', cipher_text: 'RIJVSUYVJN' },
      { key: 'DIFFERENTKEY', plaintext: 'ANOTHERTEXT', cipher_text: 'DVTYLVVGXHX' }
    ].each do |test_case|
      context "with key '#{test_case[:key]}'" do
        it 'correctly encrypts and decrypts' do
          encrypted = cipher_alg.encrypt_data(test_case[:plaintext], test_case[:key])
          expect(encrypted).to eq(test_case[:cipher_text])
          decrypted = cipher_alg.decrypt_data(encrypted, test_case[:key])
          expect(decrypted).to eq(test_case[:plaintext])
        end
      end
    end
  end
end
