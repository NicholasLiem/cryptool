require 'rails_helper'

RSpec.describe Ciphers::AutoKeyVigenereCipher do
  let(:cipher_alg) { described_class.new }

  describe '#encrypt_data and #decrypt_data' do
    [
      { key: 'TESTKEY', plain_text: 'HALOHALOBANDUNG', cipher_text: 'AEDHREJVBLBKUYU' },
      { key: 'CKIJUT', plain_text: 'MYNAMEISRAHJ', cipher_text: 'OIVJGXUQEATN' }
    ].each do |test_case|
      context "with key '#{test_case[:key]}'" do
        it 'correctly encrypts and decrypts' do
          encrypted = cipher_alg.encrypt_data(test_case[:plain_text], test_case[:key])
          expect(encrypted).to eq(test_case[:cipher_text])
          decrypted = cipher_alg.decrypt_data(test_case[:cipher_text], test_case[:key])
          expect(decrypted).to eq(test_case[:plain_text])
        end
      end
    end
  end

  describe '#square_encrypt' do
    [
      { pj: 'A', ki: 'B', result: 'B' },
      { pj: 'T', ki: 'S', result: 'L' },
      { pj: 'M', ki: 'N', result: 'Z' }
    ].each do |test_case|
      context "given pj and ki '#{test_case[:pj]}, #{test_case[:ki]}'" do
        it 'moves the character accordingly' do
          expect(cipher_alg.square_encrypt(test_case[:pj], test_case[:ki])).to eq(test_case[:result])
        end
      end
    end
  end

  describe '#square_decrypt' do
    [
      { cj: 'B', ki: 'B', result: 'A' },
      { cj: 'L', ki: 'S', result: 'T' },
      { cj: 'Z', ki: 'N', result: 'M' }
    ].each do |test_case|
      context "given cj and ki '#{test_case[:cj]}, #{test_case[:ki]}'" do
        it 'moves the character accordingly' do
          expect(cipher_alg.square_decrypt(test_case[:cj], test_case[:ki])).to eq(test_case[:result])
        end
      end
    end
  end
end
