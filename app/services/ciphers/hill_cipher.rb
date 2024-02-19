require 'matrix'

module Ciphers
  class HillCipher < EncryptionService
    include Utils

    ALPHABET              = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze
    SPECIAL_KEY_MARK      = '#'.freeze
    SPECIAL_DATA_MARK     = "$".freeze
    BASE                  = 'A'.ord
    MODULUS               = ALPHABET.size

    def encrypt_data(data, key)
      key_array = preprocess_key_text(key)
      data_array = preprocess_plain_text(data, key_array.size)
      encrypt(data_array, key_array)
    end

    def decrypt_data(cipher_text, key)
      key_array = preprocess_key_text(key)
      data_array = preprocess_plain_text(cipher_text, key_array.size)
      decrypt(data_array, key_array)
    end

    def encrypt(data_array, key_array)
      result = ''
      key_matrix = Matrix[*key_array]

      data_array.each do |data_slice|
        data_vector = Matrix.column_vector(data_slice)
        encrypted_matrix = key_matrix * data_vector
        encrypted_matrix.column(0).to_a.each do |num|
          result += ALPHABET[num % ALPHABET.size]
        end
      end

      result
    end

    def preprocess_plain_text(data, slice_length)
      return Array.new(slice_length) { Array.new(slice_length, SPECIAL_DATA_MARK.ord - BASE) } if data.nil? || data.empty?

      sliced_data = data.upcase.chars.each_slice(slice_length).to_a
      sliced_data.map! do |slice|
        slice.fill(SPECIAL_DATA_MARK, slice.length...slice_length) if slice.length < slice_length
        slice.map { |char| char.ord - BASE }
      end

      sliced_data
    end

    def preprocess_key_text(key)
      # Builds key array from key string
      result_arr = []
      n = Math.sqrt(key.length).ceil
      padded_key = key.ljust(n * n, SPECIAL_KEY_MARK)
      (0...n).each do |i|
        result_arr << padded_key[i * n, n].chars.map(&:ord)
      end
      result_arr
    end

    def decrypt(data_array, key_array)
      result = ''
      key_matrix = Matrix[*key_array]
      inverse_key_matrix = inverse_matrix(key_matrix)
      data_array.each do |data_slice|
        data_vector = Matrix.column_vector(data_slice)
        decrypted_matrix = inverse_key_matrix * data_vector
        decrypted_matrix.column(0).to_a.each do |num|
          result += ALPHABET[num.modulo(MODULUS)]
        end
      end

      result
    end

    def inverse_matrix(matrix)
      det = matrix.determinant
      raise 'Matrix is not invertible' if det.zero?

      det_mod_inverse = modular_inverse(det, MODULUS)
      adjugate = matrix.adjugate
      (adjugate * det_mod_inverse).map { |e| e.modulo(MODULUS) }
    end

    def modular_inverse(number, modulus)
      g, x = extended_gcd(number, modulus)
      raise 'Modular inverse does not exist' if g != 1

      x % modulus
    end

    def extended_gcd(a, b) # rubocop:disable Naming/MethodParameterName
      return [b, 0, 1] if (a % b).zero?

      g, x, y = extended_gcd(b, a % b)
      [g, y, x - (y * (a / b).floor)]
    end
  end
end
