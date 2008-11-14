class AddUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        t.string :first_name, :last_name, :email
    end
  end

  def self.down
    drop_table :users
  end
end
