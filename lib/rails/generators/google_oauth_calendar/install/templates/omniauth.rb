Rails.application.config.middleware.use OmniAuth::Builder do
  scopes = [
      # we need the profile scope in order to login
      "https://www.googleapis.com/auth/userinfo.profile",
      # this and other scopes could be added, but match them up with the
      # features you requested in your API Console
      "https://www.googleapis.com/auth/calendar"
    ]
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
           {:scope =>scopes.join(" ")}
end
