Rails.application.config.filter_parameters += [
  :password,
  :password_confirmation,
  :token,
  :authorization,
  :openai_api_key,
  :stripe_secret_key
]
