require 'rails_helper'

RSpec.describe Ciphers::EnigmaCipher do
  let(:rotor1) { Ciphers::Rotor.new('EKMFLGDQVZNTOWYHXUSPAIBRCJ', 16) } # Notch at position 16 (Q)
  let(:rotor2) { Ciphers::Rotor.new('AJDKSIRUXBLHWTMCQGZNPYFVOE', 4) }  # Notch at position 4 (E)
  let(:rotor3) { Ciphers::Rotor.new('BDFHJLCPRTXVZNYEIWGAKMUSQO', 21) } # Notch at position 21 (V)
  let(:reflector_wiring) do
    {
      'A' => 'Y', 'B' => 'R', 'C' => 'U', 'D' => 'H', 'E' => 'Q', 'F' => 'S', 'G' => 'L',
      'H' => 'D', 'I' => 'P', 'J' => 'X', 'K' => 'N', 'L' => 'G', 'M' => 'O', 'N' => 'K',
      'O' => 'M', 'P' => 'I', 'Q' => 'E', 'R' => 'B', 'S' => 'F', 'T' => 'Z', 'U' => 'C',
      'V' => 'W', 'W' => 'V', 'X' => 'J', 'Y' => 'A', 'Z' => 'T'
    }
  end
  let(:plugboard_wiring) do
    {
      'A' => 'B', 'B' => 'A', 'C' => 'D', 'D' => 'C', 'E' => 'F', 'F' => 'E',
      'G' => 'H', 'H' => 'G', 'I' => 'J', 'J' => 'I', 'K' => 'L', 'L' => 'K',
      'M' => 'N', 'N' => 'M', 'O' => 'P', 'P' => 'O', 'Q' => 'R', 'R' => 'Q',
      'S' => 'T', 'T' => 'S', 'U' => 'V', 'V' => 'U', 'W' => 'X', 'X' => 'W',
      'Y' => 'Z', 'Z' => 'Y'
    }
  end
  let(:reflector) { Ciphers::Reflector.new(reflector_wiring) }
  let(:plugboard) { Ciphers::Plugboard.new(plugboard_wiring) }
  let(:enigma) { described_class.new([rotor1, rotor2, rotor3], reflector, plugboard) }
  let(:original_message) { 'HELLOWORLD' }

  describe '#encrypt_data' do
    it 'correctly encrypts a message' do
      encrypted_message = enigma.encrypt_data(original_message)
      expect(encrypted_message).to eq("IJVWQTMUJH")
    end

    it 'correctly decrypts the encrypted message' do
      encrypted_message = enigma.encrypt_data(original_message)
      enigma.instance_variable_set(:@rotors, [rotor1, rotor2, rotor3].map do |r|
                                               r.position = 0
                                               r
                                             end)
      decrypted_message = enigma.encrypt_data(encrypted_message)
      expect(decrypted_message).to eq(original_message)
    end
  end
end
