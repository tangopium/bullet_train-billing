class Api::V1::Billing::SubscriptionSerializer < Api::V1::ApplicationSerializer
  set_type "billing/subscription"

  attributes :id,
    :team_id,
    :provider_subscription_type,
    :cycle_ends_at,
    :status,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
