# -*- encoding: utf-8 -*-
require File.expand_path('../lib/google_oauth_calendar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Johnson"]
  gem.email         = ["deafgreatdane@gmail.com"]
  gem.description   = %q{a generator for adding google-based users via omniauth, and querying google calendars}
  gem.summary       = %q{just run rails generate google_oauth_calendar:install }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "google_oauth_calendar"
  gem.require_paths = ["lib"]
  gem.version       = GoogleOauthCalendar::VERSION
end
