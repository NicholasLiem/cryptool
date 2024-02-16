class MainController < ApplicationController
  def show
    @encrypted_text = session.delete(:encrypted_text) # This also clears it after retrieval
  end
end
