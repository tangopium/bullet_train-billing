FactoryBot.define do
  factory :billing_subscription, class: "Billing::Subscription" do
    association :team
    provider_subscription { |billing_subscription| create(:billing_external_subscription, team: billing_subscription.team) }
    cycle_ends_at { "2021-08-29 09:29:06" }
  end
end
