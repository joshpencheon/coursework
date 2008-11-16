class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.string  :title
      t.text    :description
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :studies
  end
end
