Rails.application.routes.draw do
  # Web routes
  root 'main#show', as: 'main_page'

  # File handling routes
  post  'cryptool/service', to: 'main#service_gateway', as: 'service_gateway'
  get   'cryptool/download/:id', to: 'encryption#download', as: 'download_encrypted_file'
end
