class MainController < ApplicationController
  def reset_result
    @@result_encrypted_text = nil # rubocop:disable Style/ClassVars
    @@result_decrypted_text = nil # rubocop:disable Style/ClassVars
  end

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
      encrypt
    when 'DECRYPT'
      decrypt
    when 'DOWNLOAD'
      download
    else
      flash[:alert] = "Invalid service type."
      redirect_to main_page_path
    end
  end

  def encrypt
    reset_result
    input_type    = params[:input_type]
    input         = params[:input_text]
    file          = params[:file]
    algorithm_key = params[:algorithm].to_sym
    key           = params[:encryption_key]

    additional_params = sanitize_enigma_params(params)
    encryption_service = Utils.choose_service(algorithm_key, additional_params)

    if input_type == 'Binary File' && file
      input = handle_file_upload(file, encryption_service)
      session[:is_input_file] = true
    end
    if !encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) && !encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)
      input = Utils.sanitize_text(input)
      key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::AffineCipher)
    end

    if input.blank? && !(encryption_service.instance_of?(Ciphers::SuperEncryptionCipher) || encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher)) && input_type == 'Binary'
      raise InvalidInputError, "Input must contain at least a valid character"
    end
    raise InvalidInputError, "Key must contain at least a valid character" if key.blank? && !encryption_service.instance_of?(Ciphers::EnigmaCipher)

    encrypted_text = encryption_service.encrypt_data(input, key) if encryption_service
    @@result_encrypted_text = encrypted_text.dup # rubocop:disable Style/ClassVars
    encoded_encrypted_text = Utils.encode_to_base64(encrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = input.length > 50 ? "#{input.slice(0, 49)}..." : input
    session[:key] = key

    handle_result(encrypted_text, encoded_encrypted_text, encryption_service)
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to main_page_path and return
  end

  def decrypt
    reset_result
    input         = params[:input_text]
    file          = params[:file]
    input_type    = params[:input_type]
    algorithm_key = params[:algorithm].to_sym
    key           = params[:encryption_key]

    additional_params = sanitize_enigma_params(params)
    encryption_service = Utils.choose_service(algorithm_key, additional_params)

    # Only sanitize when its not 256 ASCII
    if input_type == 'Binary File' && file
      input = handle_file_upload(file, encryption_service)
      session[:is_input_file] = true
    end
    if !encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher) && !encryption_service.instance_of?(Ciphers::SuperEncryptionCipher)
      input = Utils.sanitize_text(input)
      # Special key for Affine Cipher, dont sanitize
      key = Utils.sanitize_text(key) unless encryption_service.instance_of?(Ciphers::AffineCipher)
    end

    if input.blank? && !(encryption_service.instance_of?(Ciphers::SuperEncryptionCipher) || encryption_service.instance_of?(Ciphers::ExtendedVigenereCipher)) && input_type == 'Binary'
      raise InvalidInputError, "Input must contain at least a valid character"
    end
    raise InvalidInputError, "Key must contain at least a valid character" if key.blank? && !encryption_service.instance_of?(Ciphers::EnigmaCipher)

    decrypted_text = encryption_service.decrypt_data(input, key) if encryption_service
    @@result_decrypted_text = decrypted_text.dup # rubocop:disable Style/ClassVars
    encoded_decrypted_text = Utils.encode_to_base64(decrypted_text)

    session[:cipher_name] = params[:algorithm].gsub("_", " ").upcase
    session[:input_text] = input.length > 100 ? "#{input.slice(0, 99)}..." : input
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

  def handle_file_upload(file, service)
    raise InvalidInputError, "File upload failed" unless file
    return file.read if service.instance_of?(Ciphers::ExtendedVigenereCipher) || service.instance_of?(Ciphers::SuperEncryptionCipher)
    raise InvalidInputError, "File type is not supported for this encryption algorithm" unless File.extname(file.original_filename) == '.txt'

    file.read.gsub("\n", '')
  end

  def download
    text_to_download = @@result_encrypted_text || @@result_decrypted_text
    # response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    # response.headers['Pragma'] = 'no-cache'
    # response.headers['Expires'] = '0'

    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    file_name = timestamp+"_result.txt"

    file_path = Rails.root.join('tmp', file_name)
    File.open(file_path, 'w') do |file|
      file.write(text_to_download)
    end
    send_file file_path, filename: file_name, type: "text/plain", disposition: "attachment"
  end
end
