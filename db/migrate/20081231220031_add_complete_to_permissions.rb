class AddCompleteToPermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :read, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :permissions, :read
  end
end
