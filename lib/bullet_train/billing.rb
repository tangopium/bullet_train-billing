require "bullet_train/billing/version"
require "bullet_train/billing/engine"

module BulletTrain
  module Billing
    # Your code goes here...
  end
end

def freemium_enabled?
  Billing::Product.find_by(id: "free").present?
end