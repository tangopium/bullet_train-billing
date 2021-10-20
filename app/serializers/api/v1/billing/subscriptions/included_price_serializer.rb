class Api::V1::Billing::Subscriptions::IncludedPriceSerializer < Api::V1::ApplicationSerializer
  set_type "billing/subscriptions/included_price"

  attributes :id,
    :subscription_id,
    :price_id,
    :quantity,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :subscription, serializer: Api::V1::Billing::SubscriptionSerializer
end
