class MainController < ApplicationController
  def show
    @encrypted_text = session.delete(:encrypted_text)
  end
end
