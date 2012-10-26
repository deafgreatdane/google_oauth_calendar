require 'google/api_client'

class ClientBuilder

  def self.get_client(user)
    client = Google::APIClient.new
    client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
    client.authorization.access_token = get_current_token(user)
    client
  end

  def self.get_current_token(user)
      if (user.token.nil? || (user.token_expires_at.nil? || user.token_expires_at <Time.now))
        # fetch new value here.
        client = OAuth2::Client.new(
            ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
                    :site => "https://accounts.google.com",
                    :token_url => "/o/oauth2/token",
                    :authorize_url => "/o/oauth2/auth")
        access_token = OAuth2::AccessToken.from_hash(client,
            {:refresh_token => user.refresh_token})
        access_token = access_token.refresh!
        user.token = access_token.token
        user.token_expires_at = Time.now + access_token.expires_in
        user.save
      end
      user.token
  end
end