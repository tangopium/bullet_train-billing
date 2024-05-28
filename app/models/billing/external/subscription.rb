class Billing::External::Subscription < ApplicationRecord
  belongs_to :team

  def provider_name
    "external"
  end
end
