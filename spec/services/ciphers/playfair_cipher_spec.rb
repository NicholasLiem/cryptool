require 'rails_helper'

RSpec.describe Ciphers::PlayfairCipher do
  let(:cipher_alg) { described_class.new }

  describe '#encrypt_data and #decrypt_data' do
    [
      { key: 'PLAYFAIR', plain_text: 'HELLOWORLD', cipher_text: 'KGYVRVVQGRCZ' },
      { key: 'JALANGANESHASEPULUH', plain_text: 'TEMUIIBUNANTIMALAM', cipher_text: 'MUTELVEMPGLGMGOINLQV'}
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

  describe '#generate_key_square' do
    context "when key contains duplicates and 'J'" do
      let(:key) { 'PLAYFAIREXMJ' }
      let(:expected_result) do
        [
          %w[P L A Y F],
          %w[I R E X M],
          %w[B C D G H],
          %w[K N O Q S],
          %w[T U V W Z]
        ]
      end

      it 'correctly generates a key square, removes duplicates, and replaces J with I' do
        expect(cipher_alg.generate_key_square(key)).to eq(expected_result)
      end
    end

    context 'with a key that leads to a straightforward key square' do
      let(:key) { 'SIMPLEKEY' }
      let(:expected_result) do
        [
          %w[S I M P L],
          %w[E K Y A B],
          %w[C D F G H],
          %w[N O Q R T],
          %w[U V W X Z]
        ]
      end

      it 'fills the square with remaining alphabet characters after key' do
        expect(cipher_alg.generate_key_square(key)).to eq(expected_result)
      end
    end
  end

  describe '#preprocess_plain_text' do
    it 'handles single characters' do
      expect(cipher_alg.preprocess_plain_text('A')).to eq(%w[AX])
    end

    it 'handles normal text' do
      expect(cipher_alg.preprocess_plain_text('HELLOWORLD')).to eq(%w[HE LX LO WO RL DX])
      expect(cipher_alg.preprocess_plain_text('TEMUIIBUNANTIMALAM')).to eq(%w[TE MU IX IB UN AN TI MA LA MX])
    end

    it 'handles character with J' do
      expect(cipher_alg.preprocess_plain_text('JJJJ')).to eq(%w[IX IX IX IX])
    end
  end

  describe '#preprocess_cipher_text' do
    it 'slice the string into 2' do
      expect(cipher_alg.preprocess_cipher_text('BANANA')).to eq(%w[BA NA NA])
    end
  end
end
