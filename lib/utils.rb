require 'base64'

module Utils
  module_function

  def is_integer(char)
    char.to_i.to_s == char
  end

  def sanitize_text(text)
    text.gsub(/[^a-zA-Z]/, "").upcase.encode('UTF-8')
  end

  def sanitize_enigma_text(text)
    sanitized_text = text.gsub(/[^a-zA-Z]/, '')
    sanitized_text.upcase.encode('UTF-8')
  end

  def is_letter_and_upcase(char)
    char.ord >= 65 && char.ord <= 90
  end

  def encode_to_base64(text)
    Base64.encode64(text)
  end

  def decode_from_base64(text)
    Base64.decode64(text)
  end

  def choose_service(algorithm_key, additional_params = nil)
    case algorithm_key
    when :vigenere
      Ciphers::VigenereCipher.new
    when :auto_key_vigenere
      Ciphers::AutoKeyVigenereCipher.new
    when :extended_vigenere
      Ciphers::ExtendedVigenereCipher.new
    when :playfair
      Ciphers::PlayfairCipher.new
    when :affine
      Ciphers::AffineCipher.new
    when :hill
      Ciphers::HillCipher.new
    when :super_encryption
      Ciphers::SuperEncryptionCipher.new
    when :enigma
      Ciphers::EnigmaCipher.new(additional_params)
    else
      raise EncryptionServiceError, "Algorithm is not specified"
    end
  end

  def find_index_matrix(matrix, target)
    matrix.each_with_index do |row, i|
      row.each_with_index do |element, j|
        return [i, j] if element == target
      end
    end
  end
end
