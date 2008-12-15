class CreateWatchings < ActiveRecord::Migration
  def self.up
    create_table :watchings do |t|
      t.integer :study_id
      t.integer :user_id
      t.text :notes
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :watchings
  end
end
