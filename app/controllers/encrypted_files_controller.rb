class EncryptedFilesController < ApplicationController
  def new
    @encrypted_file = EncryptedFile.new
  end

  def create
    @encrypted_file = EncryptedFile.new(encrypted_file_params)

    if @encrypted_file.save
      if params[:algorithm] == 'AES'
        service = ExampleEncryptionService.new(@encrypted_file.file_path)
        service.encrypt
      end
      redirect_to some_path, notice: "File uploaded and encrypted successfully."
    else
      render :new
    end
  end

  private

  def encrypted_file_params
    params.require(:encrypted_file).permit(:name, :file, :algorithm)
  end
end
