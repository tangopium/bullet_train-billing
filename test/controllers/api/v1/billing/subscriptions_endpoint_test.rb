require "test_helper"
require "controllers/api/test"

class Api::V1::Billing::SubscriptionsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # TODO Can we fix these failing tests?
    skip

    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @subscription = create(:billing_subscription, team: @team)
    @other_subscriptions = create_list(:billing_subscription, 3)
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(subscription_data)
    # Fetch the subscription in question and prepare to compare it's attributes.
    subscription = Billing::Subscription.find(subscription_data["id"])

    assert_equal subscription_data["provider_subscription_type"], subscription.provider_subscription_type
    assert_equal subscription_data["cycle_ends_at"], subscription.cycle_ends_at
    assert_equal subscription_data["status"], subscription.status
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal subscription_data["team_id"], subscription.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/billing/subscriptions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    subscription_ids_returned = response.parsed_body.dig("data").map { |subscription| subscription.dig("attributes", "id") }
    assert_includes(subscription_ids_returned, @subscription.id)

    # But not returning other people's resources.
    assert_not_includes(subscription_ids_returned, @other_subscriptions[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/billing/subscriptions/#{@subscription.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/billing/subscriptions/#{@subscription.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    subscription_data = Api::V1::Billing::SubscriptionSerializer.new(build(:billing_subscription, team: nil)).serializable_hash.dig(:data, :attributes)
    subscription_data.except!(:id, :team_id, :created_at, :updated_at)

    post "/api/v1/teams/#{@team.id}/billing/subscriptions",
      params: subscription_data.merge({access_token: access_token})

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/billing/subscriptions",
      params: subscription_data.merge({access_token: another_access_token})
    # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
    assert_response :forbidden
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/billing/subscriptions/#{@subscription.id}", params: {
      access_token: access_token
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # But we have to manually assert the value was properly updated.
    @subscription.reload
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/billing/subscriptions/#{@subscription.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Billing::Subscription.count", -1) do
      delete "/api/v1/billing/subscriptions/#{@subscription.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/billing/subscriptions/#{@subscription.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end
end
