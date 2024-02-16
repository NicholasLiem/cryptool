class EncryptionService
  FILE_TYPE = {
    text: 'Text',
    binary: 'Binary File'
  }.freeze

  ALGORITHMS = {
    vigenere: 'Vigenere Cipher',
  }.freeze

  def self.encrypt(text, algorithm_key, key = nil)
    algorithm = ALGORITHMS[algorithm_key.to_sym]

    case algorithm
    when ALGORITHMS[:vigenere]
      result = "test"
      result.concat(text)
      result.concat(key)
      result
    else
      nil
    end
  end
end
