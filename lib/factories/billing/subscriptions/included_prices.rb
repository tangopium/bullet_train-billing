FactoryBot.define do
  factory :billing_subscriptions_included_price, class: "Billing::Subscriptions::IncludedPrice" do
    association :subscription, factory: :billing_subscription
    price_id { "MyString" }
    quantity { 1 }
  end
end
