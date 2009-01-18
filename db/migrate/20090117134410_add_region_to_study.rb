class AddRegionToStudy < ActiveRecord::Migration
  def self.up
    add_column :studies, :region_id, :integer
  end

  def self.down
    remove_column :studies, :region_id
  end
end
