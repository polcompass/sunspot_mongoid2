require 'sunspot/mongoid2'
require 'rails'

module Sunspot::Mongoid2
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../../../../tasks/sunspot_mongoid2.rake", __FILE__)
    end
  end
end
