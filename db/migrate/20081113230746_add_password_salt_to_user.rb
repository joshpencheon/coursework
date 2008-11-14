class AddPasswordSaltToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :password_salt, :string, :null => false
  end

  def self.down
    remove_column :users, :password_salt
  end
end
