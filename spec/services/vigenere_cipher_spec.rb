require 'rails_helper'

RSpec.describe VigenereCipher do
  let(:key) { 'KEY' }
  let(:plaintext) { 'HELLOWORLD' }
  let(:cipher_text) { 'RIJVSUYVJN' }

  describe '#encrypt_data' do
    it 'correctly encrypts plaintext' do
      cipher = VigenereCipher.new
      expect(cipher.encrypt_data(plaintext, key)).to eq(cipher_text)
    end
  end

  describe '#decrypt_data' do
    it 'correctly decrypts ciphertext' do
      cipher = VigenereCipher.new
      expect(cipher.decrypt_data(cipher_text, key)).to eq(plaintext)
    end
  end
end
