class AddProductIdToSubscription < ActiveRecord::Migration[6.0]
    def change
      add_column :billing_subscriptions, :product_id, :string
      add_column :billing_subscriptions, :price_id, :string
      add_column :billing_subscriptions, :quantity, :integer

      data = Billing::Product.data

      Billing::Subscription.all.each do |subscription|
        included_price = execute("SELECT * FROM billing_subscriptions_included_prices WHERE subscription_id = '#{subscription.id}' ORDER BY created_at DESC LIMIT 1").first

        subscription.update!(
            product_id: data.find { |product| product[:prices]&.keys&.include?(included_price&.price_id) }.try(:[], :id),
            price_id: included_price&.price_id,
            quantity: included_price&.quantity
        )
      end

      change_column_null :billing_subscriptions, :product_id, false

      drop_table :billing_subscriptions_included_prices
    end
  end