module Ciphers
  class SuperEncryptionCipher < EncryptionService
    include Utils
    TOTAL_ASCII = 256

    def transposition_cipher(row, col, text)
      Array.new(row) { Array.new(col, ' ') }
      remainder = (row * col) - text.length
      (1..remainder).each do |_i|
        text += '0'
      end

      # Display Matrix
      # (0..(text.length-1)).each do |i|
      #   cur_row = i / row
      #   cur_col =  i % col
      #   matrix[cur_row][cur_col] = text[i]
      # end
      # matrix.each do |row|
      #   puts row.join(' ')
      # end

      result = ''
      (0..col - 1).each do |j|
        (0..row - 1).each do |i|
          temp_char = text[(col * i) + j]
          result += temp_char
        end
      end
      result
    end

    def encrypt_data(data, key)
      plain_text = data
      plain_text_length = plain_text.length
      key_length = key.length

      result = ""
      key_idx = 0

      # Extended Vigenere
      (0..(plain_text_length - 1)).each do |i|
        # Reset if it reaches max
        key_idx = 0 if key_idx == key_length

        temp_char = plain_text[i]
        key_char = key[key_idx]

        plain_int = temp_char.ord
        key_int = key_char.ord

        # NewChar int
        cipher_int = ((plain_int + key_int) % TOTAL_ASCII)
        cipher_char = cipher_int.chr
        # Add to result
        result += cipher_char
        # Increment
        key_idx += 1
      end
      col = key.length
      row = (result.length.to_f / col).ceil
      transposition_cipher(row, col, result)
    end

    def decrypt_data(data, key)
      cipher_text = data
      cipher_text_length = cipher_text.length
      key_length = key.length

      # Transpose back matrix
      row = key.length
      col = (cipher_text_length.to_f / row).ceil
      cipher_text = transposition_cipher(row, col, cipher_text)
      cipher_text_length = cipher_text.length

      result = ""
      key_idx = 0
      (0..(cipher_text_length - 1)).each do |i|
        # Reset if it reaches max
        key_idx = 0 if key_idx == key_length

        temp_char = cipher_text[i]
        key_char = key[key_idx]

        cipher_int = temp_char.ord
        key_int = key_char.ord

        # NewChar int
        plain_int = ((cipher_int - key_int) % TOTAL_ASCII)
        plain_char = plain_int.chr

        # Add to result
        result += plain_char

        # Increment
        key_idx += 1
      end
      result
    end
  end
end
