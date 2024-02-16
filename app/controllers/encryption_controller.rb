class EncryptionController < ApplicationController
  def encrypt_text
    # Extract parameters
    # input_type = params[:input_type]
    plain_text = params[:plain_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    # Encrypt the text
    encryption_service = choose_service(algorithm_key)

    # Go through preparation
    plain_text = prepare_text(plain_text)
    key = prepare_key(key)

    encrypted_text = encryption_service.encrypt_data(plain_text, key) if encryption_service
    handle_encryption_result(encrypted_text)
  end

  def prepare_text(text)
    # replace " " to "" and upcase
    text = text.gsub(" ", "").upcase
    return text
  end

  def prepare_key(key)
    # replace " " to "" and upcase
    key = key.gsub(" ", "").upcase
    return key
  end

  def choose_service(algorithm_key)
    case algorithm_key
      when :vigenere
        VigenereCipher.new
      else
        nil
    end
  end
  
  def handle_encryption_result(encrypted_data)
    if encrypted_data
      session[:encrypted_text] = encrypted_data
      redirect_to main_page_path
    else
      flash[:alert] = "Encryption failed."
      redirect_to main_page_path
    end
  end

  def download
    encrypted_file = EncryptedFile.find(params[:id])
    blob = encrypted_file.file.blob

    if blob.present?
      redirect_to rails_blob_url(blob)
    else
      head :not_found
    end
  end
end
