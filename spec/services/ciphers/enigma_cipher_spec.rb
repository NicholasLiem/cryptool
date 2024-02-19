require 'rails_helper'

RSpec.describe Ciphers::EnigmaCipher do
  let(:rotor1) { Ciphers::Rotor.new('EKMFLGDQVZNTOWYHXUSPAIBRCJ', Ciphers::EnigmaCipher::ROTOR_1_NOTCH) }
  let(:rotor2) { Ciphers::Rotor.new('AJDKSIRUXBLHWTMCQGZNPYFVOE', Ciphers::EnigmaCipher::ROTOR_2_NOTCH) }
  let(:rotor3) { Ciphers::Rotor.new('BDFHJLCPRTXVZNYEIWGAKMUSQO', Ciphers::EnigmaCipher::ROTOR_3_NOTCH) }
  let(:reflector) { Ciphers::Reflector.new('YRUHQSLDPXNGOKMIEBFZCWVJAT') }
  let(:plugboard) { Ciphers::Plugboard.new('BADCFEHGJILKNMPORQTSVUXWZY') }
  let(:additional_params) do
    {
      plugboard_input: 'BADCFEHGJILKNMPORQTSVUXWZY',
      rotor_1_input: 'EKMFLGDQVZNTOWYHXUSPAIBRCJ',
      rotor_2_input: 'AJDKSIRUXBLHWTMCQGZNPYFVOE',
      rotor_3_input: 'BDFHJLCPRTXVZNYEIWGAKMUSQO',
      reflector_input: 'YRUHQSLDPXNGOKMIEBFZCWVJAT'
    }
  end

  let(:enigma) { described_class.new(additional_params) }
  let(:original_message) { 'HELLOWORLD' }

  describe '#encrypt_data' do
    it 'correctly encrypts a message' do
      encrypted_message = enigma.encrypt_data(original_message, nil)
      expect(encrypted_message).to eq("IJVWQTMUJH")
    end

    it 'correctly decrypts the encrypted message' do
      encrypted_message = enigma.encrypt_data(original_message, nil)
      enigma.instance_variable_set(:@rotors, [rotor1, rotor2, rotor3].map do |r|
                                               r.position = 0
                                               r
                                             end)
      decrypted_message = enigma.decrypt_data(encrypted_message, nil)
      expect(decrypted_message).to eq(original_message)
    end
  end

  describe 'Testing the first character' do
    context '#plugboard.swap' do
      it 'correctly swaps' do
        expect(enigma.plugboard.swap('H')).to eq('G')
      end
    end

    context '#rotor.encrypt_forward' do
      it 'correctly encrypt forward' do
        expect(enigma.rotors.first.encrypt_forward('G')).to eq('D')
        expect(enigma.rotors.second.encrypt_forward('D')).to eq('K')
        expect(enigma.rotors.third.encrypt_forward('K')).to eq('X')
      end
    end

    context '#reflector' do
      it 'correctly reflects' do
        expect(enigma.reflector.reflect('X')).to eq('J')
      end
    end

    context '#rotor.encrypt_backward' do
      it 'correctly encrypt backward' do
        expect(enigma.rotors.third.encrypt_backward('J')).to eq('E')
        expect(enigma.rotors.second.encrypt_backward('E')).to eq('Z')
        expect(enigma.rotors.first.encrypt_backward('Z')).to eq('J')
      end
    end

    context '#plugboard.swap' do
      it 'correctly swaps' do
        expect(enigma.plugboard.swap('J')).to eq('I')
      end
    end
  end

  describe 'Testing the mappings' do
    context 'Reflector' do
      it 'correctly reflects characters' do
        expect(reflector.reflect('A')).to eq('Y')
        expect(reflector.reflect('Y')).to eq('A')
      end
    end

    context 'Plugboard' do
      it 'correctly swaps characters' do
        expect(plugboard.swap('A')).to eq('B')
        expect(plugboard.swap('B')).to eq('A')
        expect(plugboard.swap('C')).to eq('D')
        expect(plugboard.swap('D')).to eq('C')
        expect(plugboard.swap('E')).to eq('F')
      end
    end
  end
end
