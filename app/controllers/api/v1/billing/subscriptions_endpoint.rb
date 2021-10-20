class Api::V1::Billing::SubscriptionsEndpoint < Api::V1::Root
  helpers do
    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: "Team ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Subscription ID"
    end

    params :subscription do
      optional :provider_subscription_type, type: String, desc: Api.heading(:provider_subscription_type)
      optional :cycle_ends_at, type: DateTime, desc: Api.heading(:cycle_ends_at)
      optional :status, type: String, desc: Api.heading(:status)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "teams", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Billing::Subscription
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :team_id
    end
    oauth2
    paginate per_page: 100
    get "/:team_id/billing/subscriptions" do
      @paginated_subscriptions = paginate @subscriptions
      render @paginated_subscriptions, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :subscription
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/billing/subscriptions" do
      if @subscription.save
        render @subscription, serializer: Api.serializer
      else
        record_not_saved @subscription
      end
    end
  end

  resource "billing/subscriptions", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Billing::Subscription
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @subscription, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :subscription
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @subscription.update(declared(params, include_missing: false))
          render @subscription, serializer: Api.serializer
        else
          record_not_saved @subscription
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @subscription.destroy, serializer: Api.serializer
      end
    end
  end
end
