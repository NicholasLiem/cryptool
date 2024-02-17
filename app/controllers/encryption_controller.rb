class EncryptionController < ApplicationController
  include Utils

  def encrypt_text
    # Extract parameters
    # input_type = params[:input_type]
    input_text = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    puts params[:algorithm]

    # Encrypt the text
    encryption_service = Utils.choose_service(algorithm_key)

    # Go through preparation
    plain_text = encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) ? input_text : Utils.sanitize_text(input_text)
    key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher)

    encrypted_text = encryption_service.encrypt_data(plain_text, key) if encryption_service
    encoded_encrypted_text = Utils.encode_to_base64(encrypted_text)

    handle_encryption_result(params[:algorithm], plain_text, key, encrypted_text, encoded_encrypted_text)
  end

  def handle_encryption_result(cipher_name,
                               input_text,
                               key,
                               encrypted_data,
                               encoded_encrypted_text)
    if encrypted_data
      session[:cipher_name] = cipher_name.gsub("_", " ").upcase
      session[:input_text] = input_text
      session[:key] = key
      session[:result_text] = encrypted_data unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher)
      session[:encoded_result_text] = encoded_encrypted_text

    else
      flash[:alert] = "Encryption failed."
    end
    redirect_to main_page_path
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
