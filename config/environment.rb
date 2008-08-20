RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_resource, :action_mailer ]

  config.time_zone = 'Vienna'

  config.action_controller.session = {
    :session_key => '_kelp_session',
    :secret      => '939b9022c29046cde62930bbc798eb1db6f86fe53d8603a76b62f45f73b0885794160f0f47272b9ab2b47a07769af9c2db69ca3046cb69d5253b9a53c4545529'
  }
end
