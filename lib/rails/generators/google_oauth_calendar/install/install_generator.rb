module GoogleOauthCalendar
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "This generator installs all the snippets for users via google oauth"

      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      def add_files
        # the gems we're using
        gem "omniauth", ">= 1.0.3"
        gem "omniauth-google-oauth2"
        gem 'google-api-client'

        # wire up the omniauth strategy. This assumes you have environment
        # variables GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET
        # such as
        # export GOOGLE_CLIENT_ID = "YOUR_CLIENT_ID"
        # export GOOGLE_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
        template 'omniauth.rb', 'config/initializers/omniauth.rb'

        # this is the controller that connects oauth to user user model
        template 'sessions_controller.rb', 'app/controllers/sessions_controller.rb'
        route("match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]")
        route("match '/signin', to: 'sessions#new', :as => :signin, via: [:get, :post]")
        route("match '/signout', to: 'sessions#destroy', :as => :signout, via: [:get, :post]")
        route("match '/auth/failure', to: 'sessions#failure', via: [:get, :post]")

        # setup the user info
        generate("model User provider:string uid:string name:string email:string token:string refresh_token:string token_expires_at:datetime")

        inject_into_class "app/models/user.rb", User, <<-USER_METHODS
          def self.create_with_omniauth(auth)
            create! do |user|
              user.provider = auth['provider']
              user.uid = auth['uid']
              if auth['info']
                 user.name = auth['info']['name'] || ""
                 user.email = auth['info']['email'] || ""
              end
            end
          end
        USER_METHODS


        inject_into_class "app/controllers/application_controller.rb", ApplicationController, <<-APP_HELPERS
          helper_method :current_user
          helper_method :user_signed_in?
          helper_method :correct_user?

          private

          def current_user
            @current_user ||= User.find(session[:user_id]) if session[:user_id]
          end

          def user_signed_in?
            return true if current_user
          end

          def correct_user?
            @user = User.find(params[:id])
            unless current_user == @user
              redirect_to root_url, :alert => "Access denied."
            end
          end

          def authenticate_user!
            if !current_user
              redirect_to root_url, :alert => 'You need to sign in for access to this page.'
            end
          end
        APP_HELPERS

        # setup the home controller
        template 'home_controller.rb', 'app/controllers/home_controller.rb'
        copy_file 'index.html.erb', 'app/views/home/index.html.erb'
        copy_file 'client_builder.rb', 'lib/client_builder.rb'
        remove_file 'public/index.html'
        route "root to: 'home#index'"
      end
    end
  end
end