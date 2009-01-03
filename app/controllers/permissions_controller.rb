class PermissionsController < ApplicationController
  before_filter :find_requestee, :only => [ :new, :create ]
  before_filter :find_request,   :only => [ :grant, :reject, :destroy ]
  
  def index
    @received_requests = current_user.received_requests.pending
    @sent_requests = current_user.sent_requests.pending    
  end
  
  def new
    session[:permission_redirect] = request.referrer
    @permission = current_user.sent_requests.build(:requestee_id => @requestee.id)
  end
  
  def create
    @permission = current_user.sent_requests.build(params[:permission])
    if @permission.save
      flash[:notice] = "Your request has been sent."
      redirect_to session[:permission_redirect] || users_url
    else
      render :action => 'new'
    end
  end
  
  def grant
    @request.grant!
    redirect_to notifications_url
  end
  
  def reject
    @request.reject!
    redirect_to notifications_url
  end
  
  def destroy
    @request.destroy
    redirect_to notifications_url    
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
