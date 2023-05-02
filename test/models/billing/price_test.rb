require "test_helper"

class Billing::PriceTest < ActiveSupport::TestCase
  # TODO: This is currently a valid test because `config/models/billing/products.yml` happens to be missing
  # the trial_days attribute on all prices. If a trial_days attribute were to be added to that file, then
  # this test would still pass, but it wouldn't sevre as a check for a missing `field` declaration.
  # Since we load the yaml at boot-time we don't really have a chance to intercept the model before it
  # has been primed with data, which auto-creates fields if they don't exist. Maybe there's no great
  # way to test for the presence of the field declarations and we just figure that them being there is
  # good enough, and we don't need to test ActiveHash functionality.
  test "trial_days should be a live attribute even if products.yml doesn't specify any trial_days" do
    price = Billing::Price.first
    assert_nil price.trial_days
  end
end
