class EncryptionServiceError < StandardError
  def initialize(msg = "Encryption service failed to process the data")
    super
  end
end
