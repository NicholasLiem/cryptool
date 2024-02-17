module Utils
  module_function

  def sanitize_text(text)
    text.gsub(" ", "").upcase.encode('UTF-8')
  end

  def is_letter_and_upcase(char)
    char.ord >= 65 && char.ord <= 90
  end

  def choose_service(algorithm_key)
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
      Ciphers::EnigmaCipher.new
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
