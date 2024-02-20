# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, key: '_cryptool_session', expire_after: 14.days, max_cookie_size: 16_384
