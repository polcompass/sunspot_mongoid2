require 'sunspot_mongoid2'
Sunspot.session = Sunspot::Rails.build_session
ActionController::Base.module_eval { include(Sunspot::Rails::RequestLifecycle) }
