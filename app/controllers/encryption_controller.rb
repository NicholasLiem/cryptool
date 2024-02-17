class EncryptionController < ApplicationController
  include Utils

  def encrypt_text
    # Extract parameters
    # input_type = params[:input_type]
    input_text = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    # Encrypt the text
    encryption_service = Utils.choose_service(algorithm_key)

    # Go through preparation
    plain_text = Utils.sanitize_text(input_text)
    key = Utils.sanitize_text(key)

    encrypted_text = encryption_service.encrypt_data(plain_text, key) if encryption_service
    handle_encryption_result(encrypted_text)
  end

  def handle_encryption_result(encrypted_data)
    if encrypted_data
      session[:result_text] = encrypted_data
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
