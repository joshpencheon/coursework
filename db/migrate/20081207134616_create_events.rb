class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.text    :description
      t.string  :news_item_type
      t.integer :news_item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
