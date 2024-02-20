class MainController < ApplicationController
  def show
    @result_text = session.delete(:result_text)
    @encoded_result_text = session.delete(:encoded_result_text)
    @cipher_name = session.delete(:cipher_name)
    @input_text = session.delete(:input_text)
    @key = session.delete(:key)
    @service_type = session.delete(:service_type)
  end

  def service_gateway
    case params[:service_type].upcase
    when 'ENCRYPT'
      encrypt_text
    when 'DECRYPT'
      decrypt_text
    else
      flash[:alert] = "Invalid service type."
      redirect_to main_page_path
    end
  end

  # rubocop disable:Metrics/CyclomaticComplexity
  def encrypt_text
    # Extract parameters
    # input_type = params[:input_type]
    input_text    = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key           = params[:encryption_key]

    additional_params = sanitize_enigma_params(params)
    encryption_service = Utils.choose_service(algorithm_key, additional_params)

    # Go through preparation
    # Only sanitize when its not 256 ASCII
    if !encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) && !encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)
      input_text = Utils.sanitize_text(input_text)
      # Special key for Affine Cipher, dont sanitize
      key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::AffineCipher)
    end

    puts "test" unless input_text

    raise InvalidInputError, "Input must contain at least a valid character" if input_text.blank?
    raise InvalidInputError, "Key must contain at least a valid character" if key.blank? && !encryption_service.instance_of?(Ciphers::EnigmaCipher)

    encrypted_text = encryption_service.encrypt_data(input_text, key) if encryption_service
    encoded_encrypted_text = Utils.encode_to_base64(encrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = input_text
    session[:key] = key

    handle_result(encrypted_text, encoded_encrypted_text, encryption_service)
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to main_page_path and return
  end

  # rubocop disable:Metrics/CyclomaticComplexity
  def decrypt_text
    input_text = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    additional_params = sanitize_enigma_params(params)
    encryption_service = Utils.choose_service(algorithm_key, additional_params)

    # Only sanitize when its not 256 ASCII
    if !encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) && !encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)
      input_text = Utils.sanitize_text(input_text)
      # Special key for Affine Cipher, dont sanitize
      key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::AffineCipher)
    end

    raise InvalidInputError, "Input must contain at least a valid character" if input_text.blank?
    raise InvalidInputError, "Key must contain at least a valid character" if key.blank? && !encryption_service.instance_of?(Ciphers::EnigmaCipher)

    decrypted_text = encryption_service.decrypt_data(input_text, key) if encryption_service
    encoded_decrypted_text = Utils.encode_to_base64(decrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = input_text
    session[:key] = key

    handle_result(decrypted_text, encoded_decrypted_text, encryption_service)
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to main_page_path and return
  end

  def handle_result(result, encoded_result, encryption_service)
    if result
      session[:result_text] = result unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)
      session[:encoded_result_text] = encoded_result
    else
      flash[:alert] = "Operation failed."
    end
    redirect_to main_page_path
  end

  def sanitize_enigma_params(params)
    %i[plugboard_input rotor_1_input rotor_2_input rotor_3_input reflector_input].to_h do |key|
      [key, Utils.sanitize_enigma_text(params[key])]
    end
  end
end
