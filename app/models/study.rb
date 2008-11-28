class Study < ActiveRecord::Base
  validates_presence_of :title, :description
  
  has_many :attached_files, :dependent => :destroy
  belongs_to :user
end
