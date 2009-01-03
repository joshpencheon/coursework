ActionController::Routing::Routes.draw do |map|

  map.help '/help', :controller => 'help'
  
  map.resources :permissions,
    :only       => [ :index, :new, :create, :destroy ],
    :member     => { :grant => :put, :reject => :put }
  map.request_permission "/permissions/request/:requestee_id", 
    :controller => 'permissions',
    :action     => 'new'
  
  map.resources :notifications,
    :only       => :index, 
    :member     => { :read  => :put, :follow  => :post   },
    :collection => { :count => :get, :discard => :delete }
  
  map.resources :studies,
    :member     => { :watch => :post },
    :has_many   => :attached_files, :shallow => true
  
  map.resources :users
  
  map.with_options :controller => "users" do |user|
    user.resource :account
    user.signup "/signup", :action => "new"
  end
  
  map.resource  :user_session
  map.with_options :controller => "user_sessions" do |session|
    session.signin  "/signin",  :action => "new"
    session.signout "/signout", :action => "destroy"
  end
  
  map.root :controller => 'studies'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
