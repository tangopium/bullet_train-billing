module BulletTrain
  module Billing
    class Engine < ::Rails::Engine
      initializer "bullet_train-billing.quantity" do
        ActiveSupport::Notifications.subscribe("memberships.quantity-changed") do |_name, _start, _finish, _id, payload|
          billing_subscription = payload[:team].current_billing_subscription

          next unless billing_subscription.present?

          # if not billing per seat, return
          next unless billing_subscription.price[:quantity] == "memberships"

          new_quantity = billing_subscription.price.calculate_quantity(payload[:team])

          # return if quantity hasn't changed
          next if billing_subscription[:quantity] == new_quantity

          ActiveSupport::Notifications.instrument("memberships.provider-subscription-quantity-changed", {provider_subscription: billing_subscription.provider_subscription, price:, quantity: new_quantity})
        end
      end
    end
  end
end
