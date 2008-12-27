class NotificationsController < ApplicationController
  
  before_filter :authorize
  before_filter :find_notification, :only => [ :read, :follow ]

  def index
    @notifications = current_user.notifications.preloading.most_recent_first.paginate(:page => params[:page], :per_page => 5)
  end

  def count
    render :text => current_user.notifications.unread.count
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
    if params[:read]
      @notifications = @notifications.read
    end
    @notifications.destroy_all
    
    redirect_to notifications_url
  end

  private 
  
  def find_notification
    @notification = Notification.find(params[:id])
  end

end
