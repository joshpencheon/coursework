class AddNotesToAttachedFiles < ActiveRecord::Migration
  def self.up
    add_column :attached_files, :notes, :text
  end

  def self.down
    remove_column :attached_files, :notes
  end
end
