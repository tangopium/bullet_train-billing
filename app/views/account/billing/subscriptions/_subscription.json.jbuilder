json.extract! subscription,
  :id,
  :team_id,
  :provider_subscription_type,
  :cycle_ends_at,
  :status,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_billing_subscription_url(subscription, format: :json)
