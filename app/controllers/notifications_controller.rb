class NotificationsController < ApplicationController
  
  before_filter :authorize,            :except => [ :feed ]
  before_filter :authorize_from_token, :only   => [ :feed ]
  before_filter :find_notification,    :only   => [ :read, :follow ]
  
  caches_action :show

  def index
    @notifications = current_user.notifications.preloading.most_recent_first.paginate(:page => params[:page], :per_page => 5)
    if params[:referrer] == 'tab' && @notifications.empty? && !current_user.notification_count.zero?
      return redirect_to(permissions_url)
    end
  end
  
  def feed
    @notifications = @tokened_user.notifications.preloading.most_recent_first
  end
  
  def show
    @notification = current_user.notifications.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def count
    render :text => current_user.notification_count
  end

  def read
    @notification.toggle!(:read)
    
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js
    end
  end
  
  def follow
    @notification.read!    
    @target = @notification.event.news_item
    
    respond_to do |format|
      format.html { redirect_to @target }
      format.js
    end
  end
  
  def discard
    @notifications = current_user.notifications
    @notifications = @notifications.read if params[:read]
    
    @notifications.destroy_all
    redirect_to notifications_url
  end

  private 
  
  def find_notification
    @notification = Notification.find(params[:id])
  end
  
  def authorize
    unless current_user
      flash[:warn] = 'You cannot access that page.'
      redirect_to studies_url
    end
  end
  
  def authorize_from_token
    unless @tokened_user = User.find_by_token(params[:token])
      flash[:warn] = 'You cannot access that page.'
      redirect_to studies_url      
    end
  end

end
