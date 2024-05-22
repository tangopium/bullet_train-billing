class AddProductIdToSubscription < ActiveRecord::Migration[6.0]
    def change
      add_column :billing_subscriptions, :product_id, :string

      data = Billing::Product.data

      Billing::Subscription.all.each do |subscription|
          subscription.update!(product_id: data.find { |product| product[:prices]&.keys&.include?(subscription.included_prices.last&.price_id) }.try(:[], :id))
      end

      change_column_null :billing_subscriptions, :product_id, false
    end
  end