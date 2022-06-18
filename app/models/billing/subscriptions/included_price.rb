class Billing::Subscriptions::IncludedPrice < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :subscription
  belongs_to :price, class_name: "Billing::Price"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :subscription
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # TODO Figure out how to do this same thing with non-Active Record associations.
  # validates :price, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_prices
    Billing::Price.all
  end

  # 🚅 add methods above.
end
