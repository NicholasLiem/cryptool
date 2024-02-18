module Ciphers
  class EnigmaCipher < EncryptionService
    include Utils

    attr_reader :rotors, :reflector, :plugboard

    def initialize(rotors, reflector, plugboard)
      super()
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
      # Disclaimer: Penjelasan menggunakan settingan di spec (spec/services/ciphers/enigma_cipher_spec.rb)
      # Position: 0
      # Plugboard: Input 'H' -> Output 'G'
      char = @plugboard.swap(char)

      # Karena ada 3 rotor:
      # Rotor 1: Input 'G' -> Output 'D'
      # Rotor 2: Input 'D' -> Output 'K'
      # Rotor 3: Input 'K' -> Output 'X'
      @rotors.each { |rotor| char = rotor.encrypt_forward(char) }

      # Reflector: Input 'X' -> Output 'J'
      char = @reflector.reflect(char)

      # Dibalik dengan settingan yang sama:
      # Rotor 3: Input 'J' -> Output 'E'
      # Rotor 2: Input 'E' -> Output 'Z'
      # Rotor 1: Input 'Z' -> Output 'J'
      @rotors.reverse.each { |rotor| char = rotor.encrypt_backward(char) }

      # Swap lagi dengan plugboard
      # Plugboard: Input 'J' -> Output 'I'
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
    # Mirip plugboard
    def initialize(reflection)
      @reflection = reflection
    end

    def reflect(letter)
      @reflection[letter]
    end
  end

  class Plugboard
    # Diinitialize dengan melakukan swapping manual
    # Inputnya misalnya seperti ini { 'A' => 'B', 'B' => 'A', etc }
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
      # Stepping the position everytime the rotor is used to encrypt 1 char
      @position = (@position + 1) % ALPHABET.size
    end

    def encrypt_forward(letter)
      # Basically just mapping dari letter -> next "encrypted" letter
      # Contoh untuk ROTOR dengan @wiring EKMFLGDQVZNTOWYHXUSPAIBRCJ dan @position = 0
      # Char to encrypt "H" -> (Mapped forward to) "D"
      index = (ALPHABET.index(letter) + @position) % ALPHABET.size
      @wiring[index]
    end

    def encrypt_backward(letter)
      # Kebalikan dari encryrpt_forward dari input letter yang datang dari belakang
      # Cari char yang bersesuaian dengan posisinya
      index = @wiring.index(letter)
      ALPHABET[(index - @position) % ALPHABET.size]
    end
  end
end
