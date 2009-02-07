class PermissionsController < ApplicationController
  before_filter :find_requestee, :only => [ :new, :create ]
  before_filter :find_request,   :only => [ :grant, :reject, :destroy ]
  
  def index
    @received_requests = current_user.received_requests.pending
    @sent_requests = current_user.sent_requests
  end
  
  def new
    if current_user.has_sent_request_to?(@requestee)
      flash[:notice] = "You've already sent a request to #{@requestee.name(:short)} - please be patient."
      redirect_to @requestee
    end
    
    if @requestee == current_user
      flash[:notice] = "That's you!"
      redirect_to @requestee
    end

    session[:permission_redirect] = request.referrer
    @permission = current_user.sent_requests.build(:requestee_id => @requestee.id)
  end
  
  def create
    params[:permission][:granted] = false
    
    @permission = current_user.sent_requests.build(params[:permission])
    if current_user.has_sent_request_to?(@requestee) || @permission.save
      flash[:notice] = "Your request has been sent. Please wait for a response."
      redirect_to session[:permission_redirect] || permissions_url
    else
      render :action => 'new'
    end
  end
  
  def grant
    if @request.grant
      flash[:notice] = "Permission granted."
    end
    redirect_to permissions_url
  end
  
  def reject
    if @request.reject
      flash[:notice] = "Permission revoked."
    end
    redirect_to permissions_url
  end
  
  def destroy
    @request.destroy
    redirect_to permissions_url    
  end
  
  private
  
  def find_request
    requestee_id = params[:id]
    @request = current_user.find_request_from(requestee_id)
  end
  
  def find_requestee
    @requestee = User.find(params[:requestee_id] || params[:permission][:requestee_id])
  end
end
