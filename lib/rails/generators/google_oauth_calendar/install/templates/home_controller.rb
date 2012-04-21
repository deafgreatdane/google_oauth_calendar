class HomeController < ApplicationController
  require 'google/api_client'
  def index
    if (user_signed_in? )
      client = Google::APIClient.new
      client.authorization.client_id = current_user.token

      client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
      client.authorization.access_token = current_user.token;

      service = client.discovered_api('calendar', 'v3')
      result = client.execute(:api_method => service.calendar_list.list)

      @calendars = result.data
    end

  end
end