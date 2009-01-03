class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :requestee_id, 
                :requester_id
      t.string  :message
      t.boolean :granted, :default => false, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
