module BillingHelper
  def smaller_currency_symbol(string)
    # TODO Will this work for every currency?
    string.gsub(/([^0-9.,])/, '<small class="font-smaller">\1</small>').html_safe
  end

  def group_products_by_duration(products)
    product_groups = {}
    products.each { |product|
      product.prices.each { |price|
        product_groups[price.duration_key] ||= []
      }
    }

    products.each { |product|
      if product.prices.any?
        product.prices.each { |price|
          product_groups[price.duration_key] << product
        }
      else
        product_groups.each { |duration_key, group|
          group << product
        }
      end
    }

    product_groups
  end

  # TODO Make this support more than monthly and annual.
  def calculate_discount(product, subject_duration, baseline_duration)
    months_per_interval = {
      month: 1.0,
      year: 12.0
    }

    subject = product.prices.find { |price| price.duration_key == subject_duration }
    baseline = product.prices.find { |price| price.duration_key == baseline_duration }

    subject_cost_per_month = subject.amount / (months_per_interval[subject.interval.to_sym] * subject.duration)
    baseline_cost_per_month = baseline.amount / (months_per_interval[baseline.interval.to_sym] * baseline.duration)

    (1.0 - (subject_cost_per_month / baseline_cost_per_month)) * 100
  end
end
