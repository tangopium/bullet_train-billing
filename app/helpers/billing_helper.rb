module BillingHelper
  def smaller_currency_symbol(string)
    # TODO Will this work for every currency?
    string.gsub(/([^0-9.,])/, '<small class="font-smaller">\1</small>').html_safe
  end

  def group_prices_by_duration(prices)
    prices.group_by { |price| [price.duration == 1 ? nil : price.duration, price.interval.pluralize(price.duration)].compact.join("_").to_sym }
  end

  # TODO Make this support more than monthly and annual.
  def calculate_discount(subject, baseline)
    months_per_interval = {
      month: 1.0,
      year: 12.0,
    }

    subject_cost_per_month = subject.amount / (months_per_interval[subject.interval.to_sym] * subject.duration)
    baseline_cost_per_month = baseline.amount / (months_per_interval[baseline.interval.to_sym] * baseline.duration)

    (1.0 - (subject_cost_per_month / baseline_cost_per_month)) * 100
  end
end
