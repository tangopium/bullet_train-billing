class Billing::Product < ApplicationHash
  self.data = YAML.load_file("config/models/billing/products.yml").map do |key, value|
    {"id" => key}.merge(value)
  end

  has_many :prices, class_name: "Billing::Price"

  def label_string
    I18n.t("billing/products.#{id}.name")
  end
end
