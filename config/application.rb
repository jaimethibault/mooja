require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "attachinary/orm/active_record"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mooja
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
    end
  # Allows Rails to find the fonts and to use them properly
  # solution found here : https://www.youtube.com/watch?v=MrQnAg5YG3g
  # and here : https://coderwall.com/p/v5c8kq/web-fonts-and-rails-asset-pipeline
  config.assets.enabled = true
  config.assets.paths << Rails.root.join("app", "assets", "fonts")
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
