class MainController < ApplicationController
  def show
    @result_text = session.delete(:result_text)
    @encoded_result_text = session.delete(:encoded_result_text)
  end
end
