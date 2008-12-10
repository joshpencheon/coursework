class Event < ActiveRecord::Base
  belongs_to :news_item, :polymorphic => true
end
