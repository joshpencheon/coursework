class NotificationsController < ApplicationController
  
  before_filter :authorize
  before_filter :find_notification, :only => [ :read, :follow ]

  def index
    @notifications = current_user.notifications.preloading.most_recent_first.paginate(:page => params[:page], :per_page => 5)
    if params[:referrer] == 'tab' && @notifications.empty? && !current_user.notification_count.zero?
      return redirect_to permissions_url
    end
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
    unless can_edit?(@notification)
      flash[:warn] = 'You cannot access that page.'
      redirect_to studies_url
    end
  end

end
