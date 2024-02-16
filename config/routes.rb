Rails.application.routes.draw do
  # Web routes
  root 'main#show', as: 'main_page'

  # File handling routes
  post  'cryptool/encrypt/text', to: 'encryption#encrypt_text', as: 'encrypt_text'
  post  'cryptool/encrypt/file', to: 'encryption#encrypt_file', as: 'encrypt_file'
  post  'cryptool/decrypt/text'
  post  'cryptool/decrypt/file'
  get   'cryptool/download/:id', to: 'encryption#download', as: 'download_encrypted_file'
end
