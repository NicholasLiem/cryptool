class MainController < ApplicationController
  def show
    @result_text = session.delete(:result_text)
    # @result_text = session[:result_text]
    @encoded_result_text = session.delete(:encoded_result_text)
    # @encoded_result_text = session[:encoded_result_text]
    @cipher_name = session.delete(:cipher_name)
    @input_text = session.delete(:input_text)
    @key = session.delete(:key)
    @service_type = session.delete(:service_type)
  end

  def service_gateway
    case params[:service_type]
    when 'encrypt'
      encrypt_text
    when 'decrypt'
      decrypt_text
    else
      flash[:alert] = "Invalid service type."
      redirect_to main_page_path
    end
  end

  def encrypt_text
    # Extract parameters
    # input_type = params[:input_type]
    input_text = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    # Encrypt the text
    encryption_service = Utils.choose_service(algorithm_key)

    # Go through preparation
    plain_text = encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher) ? input_text : Utils.sanitize_text(input_text)
    key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)

    encrypted_text = encryption_service.encrypt_data(plain_text, key) if encryption_service
    encoded_encrypted_text = Utils.encode_to_base64(encrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = plain_text
    session[:key] = key

    handle_encryption_result(encrypted_text, encoded_encrypted_text, encryption_service)
  end

  def handle_encryption_result(encrypted_data,
                               encoded_encrypted_text,
                               encryption_service)
    if encrypted_data
      session[:result_text] = encrypted_data unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)
      session[:encoded_result_text] = encoded_encrypted_text

    else
      flash[:alert] = "Encryption failed."
    end
    redirect_to main_page_path
  end

  def decrypt_text
    input_text = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    encryption_service = Utils.choose_service(algorithm_key)

    input_text = Utils.sanitize_text(input_text)
    key = Utils.sanitize_text(key)

    decrypted_text = encryption_service.decrypt_data(input_text, key) if encryption_service
    encoded_decrypted_text = Utils.encode_to_base64(decrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = input_text
    session[:key] = key

    handle_decryption_result(decrypted_text, encryption_service, encoded_decrypted_text)
  end

  def handle_decryption_result(decrypted_data, encryption_service, encoded_decrypted_text)
    if decrypted_data
      session[:result_text] = decrypted_data unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher)
      session[:encoded_result_text] = encoded_decrypted_text
    else
      flash[:alert] = "Decryption failed."
    end
    redirect_to main_page_path
  end
end
