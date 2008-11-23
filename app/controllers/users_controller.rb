class UsersController < ApplicationController
  
  before_filter :find_user, :except => [ :index, :new, :create ]

  def index
    @users = User.all
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
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated..."
      redirect_to root_url
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end
  
  private
  
  def find_user
    @user = current_user
  end
  
end
