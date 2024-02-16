class EncryptionService
  def encrypt_data(data, key)
    raise NotImplementedError, "This #{self.class} cannot respond to:"
  end

  def decrypt_data(data, key)
    raise NotImplementedError, "This #{self.class} cannot respond to:"
  end
end
