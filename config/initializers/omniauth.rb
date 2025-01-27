Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET_KEY'],
           {
             secure_image_url: true,
             image_size: 'original',
             callback_path: '/auth/twitter2/callback'
           }
end
