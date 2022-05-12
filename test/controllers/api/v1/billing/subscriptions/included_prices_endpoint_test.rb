require "test_helper"
require "controllers/api/test"

class Api::V1::Billing::Subscriptions::IncludedPricesEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @subscription = create(:billing_subscription, team: @team)
    @included_price = create(:billing_subscriptions_included_price, subscription: @subscription)
    @other_included_prices = create_list(:billing_subscriptions_included_price, 3)
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(included_price_data)
    # Fetch the included_price in question and prepare to compare it's attributes.
    included_price = Billing::Subscriptions::IncludedPrice.find(included_price_data["id"])

    assert_equal included_price_data["price_id"], included_price.price_id
    assert_equal included_price_data["quantity"], included_price.quantity
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal included_price_data["subscription_id"], included_price.subscription_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/billing/subscriptions/#{@subscription.id}/included_prices", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    included_price_ids_returned = response.parsed_body.dig("data").map { |included_price| included_price.dig("attributes", "id") }
    assert_includes(included_price_ids_returned, @included_price.id)

    # But not returning other people's resources.
    assert_not_includes(included_price_ids_returned, @other_included_prices[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/billing/subscriptions/included_prices/#{@included_price.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/billing/subscriptions/included_prices/#{@included_price.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    included_price_data = Api::V1::Billing::Subscriptions::IncludedPriceSerializer.new(build(:billing_subscriptions_included_price, subscription: nil)).serializable_hash.dig(:data, :attributes)
    included_price_data.except!(:id, :subscription_id, :created_at, :updated_at)

    post "/api/v1/billing/subscriptions/#{@subscription.id}/included_prices",
      params: included_price_data.merge({access_token: access_token})

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    post "/api/v1/billing/subscriptions/#{@subscription.id}/included_prices",
      params: included_price_data.merge({access_token: another_access_token})
    # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
    assert_response :forbidden
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/billing/subscriptions/included_prices/#{@included_price.id}", params: {
      access_token: access_token,
      quantity: 2
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # But we have to manually assert the value was properly updated.
    @included_price.reload
    assert_equal @included_price.quantity, 2
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/billing/subscriptions/included_prices/#{@included_price.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Billing::Subscriptions::IncludedPrice.count", -1) do
      delete "/api/v1/billing/subscriptions/included_prices/#{@included_price.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/billing/subscriptions/included_prices/#{@included_price.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end
end
