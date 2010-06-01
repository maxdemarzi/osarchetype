ActionController::Routing::Routes.draw do |map|
  map.signup '/signup/:invite_code', :controller => 'users', :action => 'new'

  map.resource :invitation, :only => [:new, :create]
  map.autocomplete_for_contact_email 'autocomplete_for_contact_email', :controller => 'invitations', :action => 'autocomplete_for_contact_email'

  map.resources :users  
  map.resources :external_users

  map.resources :oauth_consumers,:member=>{:callback=>:get}
  map.resources :contacts, :collection => { :autocomplete_for_contact_email => :get}
  map.connect   '/contacts/import/:type', :controller => 'contacts', :action => 'import'

  map.resources :educations
  map.resources :positions
  map.connect 'profiles/:username', :controller => 'profiles', :action => 'show'
  map.resources :profiles
  map.resources :messages


  map.suggestions 'suggestions', :controller => 'pages', :action => 'suggestions'
  map.people 'people', :controller => 'pages', :action => 'people'
  map.jobs 'jobs', :controller => 'pages', :action => 'jobs'
  map.auth 'auth', :controller => 'auth', :action => 'index'



  # The priority is based upon order of creation: first created -> highest priority.

  map.root                :controller => 'pages', :action => 'home'


  map.login 'login', :controller => 'user_sessions', :action => 'new'  
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'  
  map.register 'register', :controller => 'users', :action => 'new'  
  map.resources :user_sessions 

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
