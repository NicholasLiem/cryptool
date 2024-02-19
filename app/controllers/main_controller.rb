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

  def encrypt_text # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    # Extract parameters
    # input_type = params[:input_type]
    raise InvalidInputError, "Input text cannot be blank" if params[:input_text].blank?
    raise InvalidInputError, "Encryption key cannot be blank" if params[:encryption_key].blank?

    input_text    = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key           = params[:encryption_key]

    additional_params = sanitize_enigma_params(params)
    encryption_service = Utils.choose_service(algorithm_key, additional_params)

    # Go through preparation
    plain_text = encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher) ? input_text : Utils.sanitize_text(input_text)
    key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)

    encrypted_text = encryption_service.encrypt_data(plain_text, key) if encryption_service
    encoded_encrypted_text = Utils.encode_to_base64(encrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = plain_text
    session[:key] = key

    handle_result(encrypted_text, encoded_encrypted_text, encryption_service)
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to main_page_path and return
  end

  def decrypt_text # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    raise InvalidInputError, "Input text cannot be blank" if params[:input_text].blank?
    raise InvalidInputError, "Encryption key cannot be blank" if params[:encryption_key].blank?

    input_text = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    additional_params = sanitize_enigma_params(params)
    encryption_service = Utils.choose_service(algorithm_key, additional_params)

    input_text = Utils.sanitize_text(input_text) unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)
    key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)

    decrypted_text = encryption_service.decrypt_data(input_text, key) if encryption_service
    encoded_decrypted_text = Utils.encode_to_base64(decrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = input_text
    session[:key] = key

    handle_result(decrypted_text, encryption_service, encoded_decrypted_text)
  rescue StandardError => e
    puts e.message
    redirect_to main_page_path and return
  end

  def handle_result(result, encoded_result, direction)
    if result
      unless @encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) || (direction == :decrypt && @encryption_service.instance_of?(Ciphers::SuperEncryptionCipher))
        session[:result_text] = result
      end
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
