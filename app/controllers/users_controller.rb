class UsersController < ApplicationController
  layout "basic"
  
  before_filter :find_user, :except => [ :index, :new, :create ]

  def index
    @users = User.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created..."
      redirect_to @user
    else
      render :action => "new"
    end
  end
  
  def edit
  end
  
  def update
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
  
  def find_user
    @user = @user_session
  end
  
end
