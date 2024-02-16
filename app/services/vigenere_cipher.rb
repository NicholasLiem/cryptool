class VigenereCipher < EncryptionService
  def encrypt_data(data, key)
    "Encrypted with Vigenere: #{data} \n\nusing key: #{key}"
  end

  def decrypt_data(data, key)
    "Decrypted with Vigenere: #{data} \n\nusing key: #{key}"
  end
end
