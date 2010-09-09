# This actually can cause issues:(
# require 'dm-rails/middleware/identity_map'

class ApplicationController < ActionController::Base
  # use Rails::DataMapper::Middleware::IdentityMap
  extend Yogo::Chainable
  protect_from_forgery
  
  # Adds in the awesome with_responder block
  # Allows modification of the current controllers responder object through blocks
  extendable do
    def with_responder(&block)
      self.responder = Class.new(self.responder || ::ActionController::Responder)
      self.responder.extend(Yogo::Chainable)
      self.responder.chainable(&block)
      self.responder
    end
  end
end
