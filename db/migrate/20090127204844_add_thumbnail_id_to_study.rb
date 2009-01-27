class AddThumbnailIdToStudy < ActiveRecord::Migration
  def self.up
    add_column :studies, :thumbnail_id, :integer
  end

  def self.down
    remove_column :studies, :thumbnail_id
  end
end
