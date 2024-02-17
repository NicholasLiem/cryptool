class VigenereCipher < EncryptionService
  include Utils

  def encrypt_data(data, key)
    plain_text = data
    plain_text_length = plain_text.length
    key_length = key.length

    result = ""
    key_idx = 0
    (0..(plain_text_length - 1)).each do |i|
      # Reset if it reaches max
      key_idx = 0 if key_idx == key_length

      temp_char = plain_text[i]
      key_char = key[key_idx]

      # Check if it is a letter and upcase
      if Utils.is_letter_and_upcase(temp_char)
        plain_int = temp_char.ord - 65
        key_int = key_char.ord - 65

        # NewChar int
        cipher_int = ((plain_int + key_int) % 26) + 65
        cipher_char = cipher_int.chr

        # Add to result
        result += cipher_char

        # Increment
        key_idx += 1

      # If not, leave it as it is
      else
        result += temp_char
      end
    end
    result
  end

  def decrypt_data(data, key)
    cipher_text = data
    cipher_text_length = cipher_text.length
    key_length = key.length

    result = ""
    key_idx = 0
    (0..(cipher_text_length - 1)).each do |i|
      # Reset if it reaches max
      key_idx = 0 if key_idx == key_length

      temp_char = cipher_text[i]
      key_char = key[key_idx]

      # Check if it is a letter and upcase
      if Utils.is_letter_and_upcase(temp_char)
        cipher_int = temp_char.ord - 65
        key_int = key_char.ord - 65

        # NewChar int
        plain_int = ((cipher_int - key_int) % 26) + 65
        plain_char = plain_int.chr

        # Add to result
        result += plain_char

        # Increment
        key_idx += 1

      # If not, leave it as it is
      else
        result += temp_char
      end
    end
    result
  end
end
