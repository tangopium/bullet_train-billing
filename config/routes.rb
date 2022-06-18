Rails.application.routes.draw do
  collection_actions = [:index, :new, :create]

  namespace :account do
    shallow do
      resources :teams, only: [] do
        namespace :billing do
          resources :subscriptions do
            scope module: "subscriptions" do
              resources :included_prices, only: collection_actions
            end

            namespace :subscriptions do
              resources :included_prices, except: collection_actions
            end
          end
        end
      end
    end
  end
end
