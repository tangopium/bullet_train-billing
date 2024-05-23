class Billing::Price < ApplicationHash
  field :amount
  field :currency
  field :duration
  field :interval
  field :trial_days
  field :quantity
  field :allow_promotion_codes

  self.data = YAML.load_file("config/models/billing/products.yml").map do |product_id, product|
    if product["prices"]
      product["prices"].map do |key, value|
        {"id" => key, "product_id" => product_id, "quantity" => nil}.merge(value)
      end
    else
      []
    end
  end.flatten

  belongs_to :product, class_name: "Billing::Product"

  def label_string
    "#{product.id} @ #{currency} #{amount.to_f / 100} per #{duration} #{interval}"
  end

  def calculate_quantity(team)
    if quantity
      team.send(quantity).billable.count
    else
      1
    end
  end

  def currency_amount
    amount / 100.0
  end

  def duration_key
    [(self.duration == 1) ? nil : self.duration, self.interval.pluralize(self.duration)].compact.join("_").to_sym
  end
end
