module Ciphers
  class AffineCipher < EncryptionService
    include Utils

    BASE = 'A'.ord
    ALPHABET_LENGTH = 26

    def search_mod_inverse(m, mod)
      temp = 0
      while ((temp * m) % mod != 1)
        temp = temp + 1
      end
      return temp
    end

    def encrypt_data(data, key)
      keys = key.split
    
      if (Utils.is_integer(keys[0]) && Utils.is_integer(keys[1])) 
        m = keys[0].to_i
        b = keys[1].to_i
    
        plain_text = data
        plain_text_length = data.length
        
    
        result = ""
        for i in 0..(plain_text_length -1) do
          temp_char = plain_text[i]
    
          if (is_letter_and_upcase(plain_text[i])) 
            plain_int = temp_char.ord - BASE
    
            cipher_int = ((m * plain_int + b) % ALPHABET_LENGTH) + BASE
            cipher_char = cipher_int.chr
            result += cipher_char
          else
            result += temp_char
          end
        end
        return result
      else
        return "Not Integer Keys Detected"
      end
    end

    def decrypt_data(data, key)
      keys = key.split
    
      if (Utils.is_integer(keys[0]) && Utils.is_integer(keys[1])) 
        m = keys[0].to_i
        b = keys[1].to_i
    
        cipher_text = data
        cipher_text_length = data.length
        
        m_inv = search_mod_inverse(m, ALPHABET_LENGTH)
    
        result = ""
        for i in 0..(cipher_text_length -1) do
          temp_char = cipher_text[i]
    
          if (is_letter_and_upcase(cipher_text[i])) 
            cipher_int = temp_char.ord - BASE
    
            plain_int = ((m_inv * (cipher_int - b)) % ALPHABET_LENGTH) + BASE
            plain_char = plain_int.chr
            result += plain_char
          else
            result += temp_char
          end
        end
        return result
      else
        return "Not Integer Keys Detected"
      end
    end
  end
end
