class Api::V1::Billing::Subscriptions::IncludedPricesEndpoint < Api::V1::Root
  helpers do
    params :subscription_id do
      requires :subscription_id, type: Integer, allow_blank: false, desc: "Subscription ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Included Price ID"
    end

    params :included_price do
      optional :price_id, type: String, desc: Api.heading(:price_id)
      optional :quantity, type: String, desc: Api.heading(:quantity)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "billing/subscriptions", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Billing::Subscriptions::IncludedPrice
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :subscription_id
    end
    oauth2
    paginate per_page: 100
    get "/:subscription_id/included_prices" do
      @paginated_included_prices = paginate @included_prices
      render @paginated_included_prices, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :subscription_id
      use :included_price
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:subscription_id/included_prices" do
      if @included_price.save
        render @included_price, serializer: Api.serializer
      else
        record_not_saved @included_price
      end
    end
  end

  resource "billing/subscriptions/included_prices", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Billing::Subscriptions::IncludedPrice
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
        render @included_price, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :included_price
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @included_price.update(declared(params, include_missing: false))
          render @included_price, serializer: Api.serializer
        else
          record_not_saved @included_price
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
        render @included_price.destroy, serializer: Api.serializer
      end
    end
  end
end
