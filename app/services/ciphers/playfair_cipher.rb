module Ciphers
  class PlayfairCipher < EncryptionService
    include Utils

    ALPHABET = 'ABCDEFGHIKLMNOPQRSTUVWXYZ'.freeze

    def encrypt_data(data, key)
      data_bigram = preprocess_plain_text(data)
      key_square = generate_key_square(key)
      encrypt(data_bigram, key_square)
    end

    def decrypt_data(cipher_text, key)
      cipher_text_bigram = preprocess_cipher_text(cipher_text)
      key_square = generate_key_square(key)
      decrypt(cipher_text_bigram, key_square)
    end

    def encrypt(data_bigram, key_square) # rubocop:disable Metrics/AbcSize
      result = ""
      data_bigram.each do |item|
        first_char = item[0]
        second_char = item[1]

        first_char_index = find_index_matrix(key_square, first_char)
        second_char_index = find_index_matrix(key_square, second_char)

        if first_char_index[0] == second_char_index[0]
          # Take next col
          result += key_square[first_char_index[0]][(first_char_index[1] + 1) % 5]
          result += key_square[second_char_index[0]][(second_char_index[1] + 1) % 5]
        elsif first_char_index[1] == second_char_index[1]
          # Take next row
          result += key_square[(first_char_index[0] + 1) % 5][first_char_index[1]]
          result += key_square[(second_char_index[0] + 1) % 5][second_char_index[1]]
        else
          # Take reciprocal
          result += key_square[first_char_index[0]][second_char_index[1]]
          result += key_square[second_char_index[0]][first_char_index[1]]
        end
      end
      result
    end

    def decrypt(cipher_text_bigram, key_square) # rubocop:disable Metrics/AbcSize
      result = ""
      cipher_text_bigram.each do |item|
        first_char = item[0]
        second_char = item[1]

        first_char_index = find_index_matrix(key_square, first_char)
        second_char_index = find_index_matrix(key_square, second_char)

        if first_char_index[0] == second_char_index[0]
          # Move to the left in the same row
          result += key_square[first_char_index[0]][(first_char_index[1] - 1) % 5]
          result += key_square[second_char_index[0]][(second_char_index[1] - 1) % 5]
        elsif first_char_index[1] == second_char_index[1]
          # Move up in the same column
          result += key_square[(first_char_index[0] - 1) % 5][first_char_index[1]]
          result += key_square[(second_char_index[0] - 1) % 5][second_char_index[1]]
        else
          # Take reciprocal
          result += key_square[first_char_index[0]][second_char_index[1]]
          result += key_square[second_char_index[0]][first_char_index[1]]
        end
      end
      # Remove X
      result.gsub("X", "")
    end

    def preprocess_plain_text(text)
      # Slice plain text into bigram, add X to the end if text is odd
      # Add X also if there are two characters that the same and right next to each other
      # Change char 'J' with 'I' in input data
      text = text.gsub("J", "I")
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

    def preprocess_cipher_text(text)
      # Asumption that the cipher text is always even.
      bigrams = []
      i = 0
      while i < text.length
        bigrams << (text[i, 2])
        i += 2
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
