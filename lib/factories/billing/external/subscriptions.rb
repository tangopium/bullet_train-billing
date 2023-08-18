FactoryBot.define do
  factory :billing_external_subscription, class: "Billing::External::Subscription" do
    team { nil }
    notes { "MyText" }
  end
end
