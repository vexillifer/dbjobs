Dbjobs::Application.routes.draw do

  #get "users/index"

  #get "users/show"

  #:only => [:index, :show]

  default_url_options :host => "localhost:3000"


  get '/addresses/subregion_options' => 'addresses#subregion_options'
  get 'posts/review' => "posts#review"
  get 'posts/owned' => "posts#owned"
  # Favorites index
  get 'posts/favourites' => "posts#favourites"
  # Favourite action
  get 'posts/favourite' => "posts#favourite"
  get 'posts/unfavourite' => "posts#unfavourite"


  get 'posts/diff' => "posts#diff"
  get 'scrape_logs/scrape' => "scrape_logs#scrape"
  match '/posts/search_job_pref' => 'posts#search_job_pref', :as => 'search_job_pref'

  #linkedin auth
  get '/users/:id/callback' => "users#callback", :as => "show"
  get '/users/:id/linkedin' => "users#linkedin"

  devise_for :users
  resources :addresses
  resources :users do
    resource :profile
    resource :job_preference
  end
  resources :posts
  resources :scrape_logs, :only => [:index]
  match 'map' => "posts#map"

  # pdf file paths
  match '/users/:id/profile/resume/' => 'profiles#download_resume', :as => 'download_resume'
  match '/posts/:id/info/' => 'posts#download_post_info', :as => 'download_post_info'


  root :to => "home#index"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
 
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
