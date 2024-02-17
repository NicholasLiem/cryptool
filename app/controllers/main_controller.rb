class MainController < ApplicationController
  def show
    @result_text = session.delete(:result_text)
    # @result_text = session[:result_text]
    @encoded_result_text = session.delete(:encoded_result_text)
    # @encoded_result_text = session[:encoded_result_text]
    @cipher_name = session.delete(:cipher_name)
    @input_text = session.delete(:input_text)
    @key = session.delete(:key)
  end
end
