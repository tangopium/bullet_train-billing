json.extract! included_price,
  :id,
  :subscription_id,
  :price_id,
  :quantity,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_billing_subscriptions_included_price_url(included_price, format: :json)
