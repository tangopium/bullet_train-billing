module BillingHelper
  def smaller_currency_symbol(string)
    # TODO Will this work for every currency?
    string.gsub(/([^0-9.,])/, '<small class="font-smaller">\1</small>').html_safe
  end
end
