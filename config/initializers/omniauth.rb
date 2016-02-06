OmniAuth.config.full_host = 'http://localhost:3000'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV["THOUGHT_DOC_GOOGLE_CLIENT_ID"],
    ENV["THOUGHT_DOC_GOOGLE_SECRET"],
    image_aspect_ratio: 'square',
    image_size: 48,
    access_type: 'online',
    name: 'google'
end
