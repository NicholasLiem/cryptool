module Ciphers
  class AutoKeyVigenereCipher < EncryptionService
    include Utils

    BASE = 'A'.ord
    ALPHABET_LENGTH = 26

    def encrypt_data(data, key)
      extended_key = extend_key(data, key)
      encrypt_text(data, extended_key)
    end

    def decrypt_data(cipher_text, key)
      result = ""
      cipher_text.chars.each_with_index do |cipher_char, i|
        key_char = i < key.length ? key[i] : result[i - key.length]
        decrypted_char = square_decrypt(cipher_char, key_char)
        result += decrypted_char
      end
      result
    end

    def extend_key(data, key)
      key + data[0...(data.length - key.length)]
    end

    def encrypt_text(plain_text, extended_key)
      result = ""
      (0..(plain_text.length - 1)).each do |i|
        encrypted_char = square_encrypt(plain_text[i], extended_key[i])
        result += encrypted_char
      end
      result
    end

    def square_encrypt(pj_var, ki_var)
      # Pj = plain text char at index j
      # Ki = key text char at index i
      encrypted_position = (pj_var.ord + ki_var.ord) % ALPHABET_LENGTH
      (encrypted_position + BASE).chr
    end

    def square_decrypt(cj_var, ki_var)
      # Cj = cypher text char at index j
      # Ki = key text char at index i
      decrypted_position = (cj_var.ord - ki_var.ord) % ALPHABET_LENGTH
      (decrypted_position + BASE).chr
    end
  end
end
