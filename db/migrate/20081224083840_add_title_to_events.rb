class AddTitleToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :title, :string
  end

  def self.down
    remove_column :events, :title
  end
end
