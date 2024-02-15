Rails.application.routes.draw do
  # Web routes
  get   'cryptool/tool', to: 'main#show', as: 'main_page'
  root 'main#show'

  # File handling routes
  post  'cryptool/upload', to: 'encrypted_files#upload', as: 'upload_encrypted_file'
  get   'cryptool/download/:id', to: 'encrypted_files#download', as: 'download_encrypted_file'
end
