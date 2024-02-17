module Ciphers
  class PlayfairCipher < EncryptionService
    include Utils

    ALPHABET = 'ABCDEFGHIKLMNOPQRSTUVWXYZ'.freeze

    def encrypt_data(data, key)
      # # Generate key square
      # key_square = generate_key_square(key)
      # Change char 'J' with 'I' in input data
      data = data.gsub("J", "I")
      data_bigram = slice_text_to_bigram(data)
      key_square = generate_key_square(key)
      encrypt(data_bigram, key_square)
    end

    def encrypt(data_bigram, key_square)
      result = ""
      # Iterate
      # Check if bigram is in the same row
      # Check if bigram is in the same col
      # Last: not in the same row or col
      result
    end

    # def decrypt(key_square, char_pair)

    # end

    def slice_text_to_bigram(text)
      bigrams = []
      i = 0
      while i < text.length
        if i + 1 < text.length && text[i] == text[i + 1]
          bigrams << "#{text[i]}X"
          i += 1
        else
          bigrams << (text[i + 1] ? text[i, 2] : "#{text[i]}X")
          i += 2
        end
      end
      bigrams
    end

    def generate_key_square(key)
      # Remove duplicate character and replace J with I
      key = key.upcase.gsub("J", 'I').chars.uniq.join
      # Add the rest of ALPHABET character that is not in the key into the key
      key += ALPHABET.chars.reject { |letter| key.include?(letter) }.join
      # Turn it into 5 x 5 array
      key.chars.each_slice(5).to_a
    end
  end
end
