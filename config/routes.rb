Rails.application.routes.draw do
  collection_actions = [:index, :new, :create]

  namespace :account do
    shallow do
      resources :teams, only: [] do
        namespace :billing do
          resources :subscriptions do
            member do
              get :upgrade
            end
          end
        end
      end
    end
  end
end
