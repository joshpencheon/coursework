class AddCategoryToStudy < ActiveRecord::Migration
  def self.up
    add_column :studies, :category, :string
  end

  def self.down
    remove_column :studies, :category
  end
end
