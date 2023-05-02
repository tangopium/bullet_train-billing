require "test_helper"

class Billing::PriceTest < ActiveSupport::TestCase
  test "trial_days should be a live attribute even if products.yml doesn't specify any trial_days" do
    price = Billing::Price.first
    assert_nil price.trial_days
  end
end
