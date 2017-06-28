Rails.application.routes.draw do

  resources :news, only: [:index]
  resources :posts

  get 'real_state_directory/index'

  resources :real_state_directory, only: :index
  resources :views

  resources :saved_listings

  resources :messages

  resources :charges
  
  devise_for :users, controllers: {registrations: 'registrations', :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :users do
    put :set_language, on: :collection
  end

  namespace :account do
    resources :consumer do
      member do
        post :disable
        post :enable
      end  
    end
    resources :agent
  end

  
  resources :listings do 
    member do 
      get 'step1'
      get 'step2'
      get 'step3'
      resources :listing_photos, :only => [:create,:destroy]
    end
    collection do
      get 'search'
    end
  end

  get "for_rent", to: 'listings#index', defaults: {listing_type:Listing::LISTING_TYPE.index(:rent)}, as: 'for_rent'
  get "for_sale", to: 'listings#index', defaults: {listing_type:Listing::LISTING_TYPE.index(:sale)}, as: 'for_sale'

  get 'content/index'
  get '/about' => "content#about", :as => 'about'
  get '/how_use' => "content#how_use", :as => 'how_use'
  get '/terms' => "content#terms", :as => 'terms'
  get '/privacy' => "content#privacy", :as => 'privacy'
  
  post '/rate' => 'rater#create', :as => 'rate'



  get "/account" => 'users#index', :as => 'user_root'
  get "/account" => 'users#index', :as => 'both_root'
  get "/account" => 'users#index', :as => 'agent_root'
  get "/account" => 'users#index', :as => 'seller_root'

  root :to => 'content#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
