require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Miterra
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**/}')]
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es
    config.action_view.embed_authenticity_token_in_remote_forms = true
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    #config.logger = Logger.new(STDOUT)

    config.assets.initialize_on_precompile = false
  end
end



#def merge_keys(h_keys,h_values, new_hash = {})
  #  while key = h_keys.shift do
  #    val = h_values.shift
  #    if val[1].class == String
  #      new_hash[key[0]] = val[1]
  #    elsif val[1].class == Hash
 #       new_hash[key[0]] = merge_keys(key,val)
#      end
#    end
#    new_hash
#end

#en = YAML.load_file("#{Rails.root}/config/locales/en.yml")
#es = YAML.load_file("#{Rails.root}/config/locales/es.yml")