class AddPartnershipIdToStudy < ActiveRecord::Migration
  def self.up
    add_column :studies, :partnership_id, :integer
  end

  def self.down
    remove_column :studies, :partnership_id
  end
end
