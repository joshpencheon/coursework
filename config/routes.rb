ActionController::Routing::Routes.draw do |map|

  map.help '/help', :controller => 'help'
  
  map.resources :permissions,
    :only       => [ :index, :new, :create, :destroy ],
    :member     => { :grant => :put, :reject => :put }
  
  map.request_permission "/permissions/request/:requestee_id", 
    :controller => 'permissions',
    :action     => 'new'
  
  map.resources :notifications,
    :only       => [ :index, :show ],
    :member     => { :read  => :put, :follow => :post },
    :collection => { :feed  => :get, :count  => :get, :discard => :delete }
  
  map.resources :downloads, 
    :only       => [ ],
    :member     => { :configure => :get, :serve => :get , :build => :post }
  
  map.resources :studies, 
    :member     => { :download => :get, :watch  => :post },
    :collection => { :search   => :get } do |study|
    study.with_options :shallow => true do |s|
      s.resources :attached_files, :only => [ :show ]
      s.resources :comments,       :only => [ :create ]      
    end
  end
  
  map.resources :users
  
  map.with_options :controller => "users" do |user|
    user.resource :account
    user.signup "/signup", :action => "new"
  end
  
  map.resource :user_session
  map.with_options :controller => "user_sessions" do |session|
    session.signin  "/signin",  :action => "new"
    session.signout "/signout", :action => "destroy"
  end
  
  map.root :controller => 'studies'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
