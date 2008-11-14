class AddAuthlogicToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :login,            :string, :null => false
    add_column :users, :crypted_password, :string, :null => false
    add_column :users, :remember_token,   :string, :null => false
    add_column :users, :login_count,      :integer
  end

  def self.down
    remove_column :users, :login  
    remove_column :users, :crypted_password 
    remove_column :users, :remember_token   
    remove_column :users, :login_count
  end
end    