Rails.application.routes.draw do
  get 'encrypted_files/new', to: 'encrypted_files#new', as: 'new_encrypted_file'

  post 'encrypted_files', to: 'encrypted_files#create', as: 'encrypted_files'
end
