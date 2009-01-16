class UsersController < ApplicationController
  
  before_filter :authorize,         :except => [ :new, :create ]
  before_filter :find_user,         :only   => [ :show, :edit, :update, :destroy ]
  before_filter :authorize_as_self, :only   => [ :edit, :update ]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 5)
  end
  
  def show
  end
  
  def new
    @user = User.new
    render :layout => "basic"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created..."
      session[:welcome?] = true
      redirect_to root_url
    else
      render :action => "new", :layout => "basic"
    end
  end
  
  def edit
  end
  
  def update
    if (params[:user][:destroy_avatar] == '1') && params[:user][:avatar].blank?
      params[:user][:avatar] = nil
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated..."
      redirect_to @user
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end
  
  private
  
  def authorize_as_self
    unless current_user == @user
      flash[:warn] = 'You cannot access that page.'
      redirect_to @user
    end
  end
  
  def find_user
    @user = User.find(params[:id])
  end
  
end
