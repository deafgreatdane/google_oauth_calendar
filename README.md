# GoogleOauthCalendar

This provides a generator that installs everything you need to be able to authenticate users against
their Google identity (via oauth2), and then use the google apis to start interacting with their calendars.
This isn't limited to Google Calendars, but it's a nice starter example to demonstrate their services.

Rather than
the individual instructions at each in each gem, and stubbing your toe a half dozen times in the process, this is
a one-stop generator.

Specifically, it

* creates a User model with name &amp; email pulled from Google, and a place to store their access token
* initializes omniauth to use the google-oath2 strategy for signin
* creates a SessionsController to react to signin/signout
* installs a basic root controller that has view showing signin/signout links,
and queries the list of the user's calendars via the google/api_client

This gem allows you to install these features after your app already exists, rather than using an application
template such as [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer). This way, it makes
fewer assumptions about your other app preferences.

## Configuring Google API

You need to configure an API instance at Google for your app's use. This becomes the trust link
between the systems. You can use a regular google identity for this, Google Apps for Business or other
paid services are not required, assuming you can deal with their usage limits.

1. Go to to the [Google API Console](https://code.google.com/apis/console/), and create a new project.
(The name doesn't matter, but will probably match your rails project name)
1. Go to the service tab, and enable **Calendar API**
1. Go to the **API Access** tab, and create an OAuth 2.0 client ID
    1. pick a project name
    1. choose "web application" as the application type
    1. for "your site or hostname" choose "more options" and use

        http://localhost:3000/auth/google_oauth2/callback
1. copy the client ID and secret into environment variables, for example

        export GOOGLE_CLIENT_ID = "YOUR_CLIENT_ID"
        export GOOGLE_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
## Installation

Add this line to your application's Gemfile:

    gem 'google_oauth_calendar' , :git => 'git@github.com:deafgreatdane/google_oauth_calendar.git'

And then execute:

    $ bundle
    $ rails generate google_oauth_calendar:install
    $ rake db:migrate
    $ rails server

When you click the "signin" link, you'll be redirected to google, asked to confirm your app's use of calendar
APIs, then it direct back to your home page, signed in, and list your calendars.

At this point, you can remove the gem from your gemfile, since it's only the generator

## Where to go from here

Now you can get to work at adding the real features using your preferred patterns. Some things you'll
probably end up doing:

* add a UserController for seeing who has connected
* add "filter authenticate_user!" to your secure controllers
* learn more about the [calendar or other google apis](http://code.google.com/p/google-api-ruby-client/wiki/SupportedAPIs)
via the [google-api-client](http://code.google.com/p/google-api-ruby-client/)
* add more "redirect URLs" to your Google API console, corresponding to your stage &amp; production urls.
* add error handling for chatting with Google

Feedback and contributions are welcome, just file an issue or create pull request