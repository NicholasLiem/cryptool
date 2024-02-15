class MainController < ApplicationController
  def show
    @encrypted_file = EncryptedFile.new
  end
end
