module Ciphers
  class EnigmaCipher < EncryptionService
    include Utils

    def initialize(rotors, reflector, plugboard) # rubocop:disable Lint/MissingSuper
      @rotors = rotors
      @reflector = reflector
      @plugboard = plugboard
    end

    def encrypt_data(data)
      data.upcase.chars.map do |char|
        encrypt_char(char)
      end.join
    end

    def encrypt_char(char)
      char = @plugboard.swap(char)

      @rotors.each { |rotor| char = rotor.encrypt_forward(char) }

      char = @reflector.reflect(char)

      @rotors.reverse.each { |rotor| char = rotor.encrypt_backward(char) }

      char = @plugboard.swap(char)

      step_rotors
      char
    end

    def step_rotors
      step_next = true
      @rotors.each do |rotor|
        if step_next
          rotor.step
          step_next = rotor.position == rotor.notch
        end
      end
    end
  end

  class Reflector
    def initialize(reflection)
      @reflection = reflection
    end

    def reflect(letter)
      @reflection[letter]
    end
  end

  class Plugboard
    def initialize(swaps = {})
      @swaps = swaps
    end

    def swap(letter)
      @swaps[letter] || @swaps.key(letter) || letter
    end
  end

  class Rotor
    ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze
    attr_accessor :position
    attr_reader :wiring, :notch

    def initialize(wiring, notch, position = 0)
      @wiring = wiring
      @notch = notch
      @position = position
    end

    def step
      @position = (@position + 1) % ALPHABET.size
    end

    def encrypt_forward(letter)
      index = (ALPHABET.index(letter) + @position) % ALPHABET.size
      @wiring[index]
    end

    def encrypt_backward(letter)
      index = @wiring.index(letter)
      ALPHABET[(index - @position) % ALPHABET.size]
    end
  end
end
