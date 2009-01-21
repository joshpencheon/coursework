class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :study
  
  has_many :events, :as => :news_item
  
  validates_presence_of :content

end
