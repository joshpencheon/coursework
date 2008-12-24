class RedoEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :description, :data
    add_column    :events, :serialized,  :boolean
    add_column    :events, :type,        :string
  end

  def self.down
    remove_column :events, :type
    remove_column :events, :serialized
    rename_column :events, :data,        :description
  end
end
