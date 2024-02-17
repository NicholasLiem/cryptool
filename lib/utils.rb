module Utils
  module_function

  def sanitize_text(text)
    text.gsub(" ", "").upcase
  end

  def is_letter_and_upcase(char)
    char.ord >= 65 && char.ord <= 90
  end

  def choose_service(algorithm_key)
    case algorithm_key
    when :vigenere
      VigenereCipher.new
    when :auto_key_vigenere
      AutoKeyVigenereCipher.new
    when :extended_vigenere
      ExtendedVigenereCipher.new
    when :playfair
      PlayfairCipher.new
    when :affine
      AffineCipher.new
    when :hill
      HillCipher.new
    when :super_encryption
      SuperEncryptionCipher.new
    when :enigma
      EnigmaCipher.new
    end
  end
end
