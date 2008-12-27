class RedoEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :description, :data
  end

  def self.down
    rename_column :events, :data,        :description
  end
end
