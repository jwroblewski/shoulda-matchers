# $LOAD_PATH << File.join(File.dirname(__FILE__), 'controller_tests')
require 'shoulda/private_helpers'
require 'shoulda/active_record_helpers'
require 'shoulda/controller_tests/controller_tests.rb'
require 'shoulda/context'
require 'shoulda/general'
require 'yaml'

shoulda_options = {}

possible_config_paths = []
possible_config_paths << File.join(ENV["HOME"], ".shoulda.conf")       if ENV["HOME"]
possible_config_paths << "shoulda.conf"
possible_config_paths << File.join("test", "shoulda.conf")
possible_config_paths << File.join(RAILS_ROOT, "test", "shoulda.conf") if defined?(RAILS_ROOT) 

possible_config_paths.each do |config_file|
  if File.exists? config_file
    puts "Loading #{config_file}"
    shoulda_options = YAML.load_file(config_file).symbolize_keys
    break
  end
end

require 'shoulda/color' if shoulda_options[:color]

module Test # :nodoc:
  module Unit # :nodoc:
    class TestCase # :nodoc:

      include ThoughtBot::Shoulda::Controller
      include ThoughtBot::Shoulda::General

      class << self
        include ThoughtBot::Shoulda::Context
        include ThoughtBot::Shoulda::ActiveRecord
        # include ThoughtBot::Shoulda::General::ClassMethods    
      end
    end
  end
end

module ActionController #:nodoc:
  module Integration #:nodoc:
    class Session #:nodoc:
      include ThoughtBot::Shoulda::General::InstanceMethods
    end
  end
end
