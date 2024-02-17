class MainController < ApplicationController
  def show
    @result_text = session.delete(:result_text)
  end
end
