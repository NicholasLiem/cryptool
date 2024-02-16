Rails.application.routes.draw do
  # Web routes
  root 'main#show', as: 'main_page'

  # File handling routes
  post  'cryptool/encrypt', to: 'encrypted_files#encrypt', as: 'encrypt_text'
  post  'cryptool/upload', to: 'encrypted_files#upload', as: 'upload_encrypted_file'
  get   'cryptool/download/:id', to: 'encrypted_files#download', as: 'download_encrypted_file'
end
