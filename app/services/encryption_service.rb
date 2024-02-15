# app/services/encryption_service.rb
class EncryptionService
  def initialize(file_path)
    @file_path = file_path
  end

  def encrypt
    raise NotImplementedError, "This #{self.class} cannot respond to:"
  end
end
