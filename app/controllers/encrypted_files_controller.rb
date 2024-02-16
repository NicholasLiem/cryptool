class EncryptedFilesController < ApplicationController
  def encrypt_text
    # Extract parameters
    plain_text = params[:plain_text]
    algorithm = params[:algorithm]
    key = params[:encryption_key]

    # Encrypt the text
    encrypted_text = EncryptionService.encrypt(plain_text, algorithm, key)
    handle_encryption_result(encrypted_text)
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
