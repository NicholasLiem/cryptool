class DecryptionController < ApplicationController
  include Utils

  def decrypt_text
    input_text = params[:input_text]
    algorithm_key = params[:algorithm].to_sym
    key = params[:encryption_key]

    encryption_service = Utils.choose_service(algorithm_key)

    input_text = Utils.sanitize_text(input_text)
    key = Utils.sanitize_text(key)

    decrypted_text = encryption_service.decrypt_data(input_text, key) if encryption_service
    handle_decryption_result(decrypted_text)
  end

  def handle_decryption_result(decrypted_data)
    if decrypted_data
      session[:result_text] = decrypted_data
    else
      flash[:alert] = "Decryption failed."
    end
    redirect_to main_page_path
  end
end
