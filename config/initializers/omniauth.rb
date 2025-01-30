OmniAuth.config.allowed_request_methods = %i[get post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
    ENV['TWITTER_API_KEY'], 
    ENV['TWITTER_API_SECRET_KEY']
end
