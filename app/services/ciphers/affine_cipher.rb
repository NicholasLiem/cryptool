module Ciphers
  class AffineCipher < EncryptionService
    include Utils

    BASE = 'A'.ord
    ALPHABET_LENGTH = 26

    def search_mod_inverse(m_num, mod)
      temp = 0
      temp += 1 while (temp * m_num) % mod != 1
      temp
    end

    def encrypt_data(data, key)
      keys = key.split

      return "Not Integer Keys Detected" unless Utils.is_integer(keys[0]) && Utils.is_integer(keys[1])

      m = keys[0].to_i
      b = keys[1].to_i

      plain_text = data
      plain_text_length = data.length

      result = ""
      (0..(plain_text_length - 1)).each do |i|
        temp_char = plain_text[i]

        if is_letter_and_upcase(plain_text[i])
          plain_int = temp_char.ord - BASE

          cipher_int = (((m * plain_int) + b) % ALPHABET_LENGTH) + BASE
          cipher_char = cipher_int.chr
          result += cipher_char
        else
          result += temp_char
        end
      end
      result
    end

    def decrypt_data(data, key)
      keys = key.split

      return "Not Integer Keys Detected" unless Utils.is_integer(keys[0]) && Utils.is_integer(keys[1])

      m = keys[0].to_i
      b = keys[1].to_i

      cipher_text = data
      cipher_text_length = data.length

      m_inv = search_mod_inverse(m, ALPHABET_LENGTH)

      result = ""
      (0..(cipher_text_length - 1)).each do |i|
        temp_char = cipher_text[i]

        if is_letter_and_upcase(cipher_text[i])
          cipher_int = temp_char.ord - BASE

          plain_int = ((m_inv * (cipher_int - b)) % ALPHABET_LENGTH) + BASE
          plain_char = plain_int.chr
          result += plain_char
        else
          result += temp_char
        end
      end
      result
    end
  end
end
