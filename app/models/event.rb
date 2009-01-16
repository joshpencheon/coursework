class Event < ActiveRecord::Base
  belongs_to :news_item, :polymorphic => true
  belongs_to :user
  
  has_many :notifications, :dependent => :destroy
  
  serialize :data
  serialize :title
  
  after_save do |event|
    event.news_item.watchers.each do |user|
      user.notifications.create(:event_id => event.id)
    end
  end
  
end
