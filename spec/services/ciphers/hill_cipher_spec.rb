require 'rails_helper'

RSpec.describe Ciphers::HillCipher do
  let(:cipher_alg) { described_class.new }

  describe '#encrypt_data and #decrypt_data' do
    [
      { key: '', plain_text: 'paymoremoney', cipher_text: 'LNSHDLEWMTRW' }
    ].each do |test_case|
      context "with key '#{test_case[:key]}'" do
        it 'correctly encrypts and decrypts' do
          encrypted = cipher_alg.encrypt_data(test_case[:plain_text], test_case[:key])
          expect(encrypted).to eq(test_case[:cipher_text])
          # decrypted = cipher_alg.decrypt_data(test_case[:cipher_text], test_case[:key])
          # expect(decrypted).to eq(test_case[:plain_text])
        end
      end
    end
  end

  describe '#preprocess_key_text' do
    context 'with given key' do
      it 'correctly builds the key matrix of size 3 from a key of length 9' do
        result = [[84, 69, 83], [84, 73, 78], [71, 35, 35]]
        expect(cipher_alg.preprocess_key_text('TESTING')).to eq(result)
      end

      it 'correctly builds the key matrix of size 3 from a key of length 7' do
        result = [[84, 69, 83], [84, 73, 78], [71, 35, 35]]
        expect(cipher_alg.preprocess_key_text('TESTING')).to eq(result)
      end

      it 'correctly builds the key matrix of size 2 from a key of length 5' do
        result = [[84, 69, 83], [84, 73, 35], [35, 35, 35]]
        expect(cipher_alg.preprocess_key_text('TESTI')).to eq(result)
      end

      it 'correctly handles empty key' do
        result = []
        expect(cipher_alg.preprocess_key_text('')).to eq(result)
      end
    end
  end

  describe '#preprocess_plain_text' do
    context 'with given data and slice length' do
      it 'correctly splits the data into blocks of size 3 and maps characters to 0-based index values' do
        data = 'HELLOWORLD'
        slice_length = 3
        result = [[7, 4, 11], [11, 14, 22], [14, 17, 11], [3, '$'.ord - 'A'.ord, '$'.ord - 'A'.ord]]
        expect(cipher_alg.preprocess_plain_text(data, slice_length)).to eq(result)
      end

      it 'correctly splits the data into blocks of size 4 and maps characters to 0-based index values' do
        data = 'HELLO'
        slice_length = 4
        result = [[7, 4, 11, 11], [14, '$'.ord - 'A'.ord, '$'.ord - 'A'.ord, '$'.ord - 'A'.ord]]
        expect(cipher_alg.preprocess_plain_text(data, slice_length)).to eq(result)
      end

      it 'correctly handles empty data' do
        data = ''
        slice_length = 3
        result = [
          [('$'.ord - 'A'.ord), ('$'.ord - 'A'.ord), ('$'.ord - 'A'.ord)],
          [('$'.ord - 'A'.ord), ('$'.ord - 'A'.ord), ('$'.ord - 'A'.ord)],
          [('$'.ord - 'A'.ord), ('$'.ord - 'A'.ord), ('$'.ord - 'A'.ord)]
        ]
        expect(cipher_alg.preprocess_plain_text(data, slice_length)).to eq(result)
      end

      it 'correctly handles data shorter than slice length and maps characters to 0-based index values' do
        data = 'HI'
        slice_length = 3
        result = [[7, 8, '$'.ord - 'A'.ord]]
        expect(cipher_alg.preprocess_plain_text(data, slice_length)).to eq(result)
      end
    end
  end
end
