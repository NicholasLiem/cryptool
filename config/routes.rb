Rails.application.routes.draw do
  # Web routes
  root 'main#show', as: 'main_page'

  # File handling routes
  post  'cryptool/encrypt/text', to: 'encrypted_files#encrypt_text', as: 'encrypt_text'
  post  'cryptool/encrypt/file', to: 'encrypted_files#encrypt_file', as: 'encrypt_file'
  get   'cryptool/download/:id', to: 'encrypted_files#download', as: 'download_encrypted_file'
end
