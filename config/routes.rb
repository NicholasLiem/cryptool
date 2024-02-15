Rails.application.routes.draw do
  get 'encrypted_files/new', to: 'encrypted_files#new', as: 'new_encrypted_file'

  post 'cryptool', to: 'encrypted_files#create', as: 'encrypted_files'
  get 'cryptool/download/:id', to: 'encrypted_files#download_file', as: 'download_encrypted_file'
end
