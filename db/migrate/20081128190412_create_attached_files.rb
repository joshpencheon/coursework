class CreateAttachedFiles < ActiveRecord::Migration
  def self.up
    create_table :attached_files do |t|
      t.integer :study_id
      t.integer :download_count, :default => 0
      
      # These are for Paperclip:
      t.integer :document_file_size
      t.string  :document_content_type,
                :document_file_name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :attached_files
  end
end
