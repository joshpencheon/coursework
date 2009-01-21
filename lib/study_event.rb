class StudyEvent
  include EventMethods
  
  def before_save(study)
    @data = {}
    
    # Changes to the study
    unless study.changes.blank?
      @data[:study] = change_strings(study.changes)
    end
    
    @data[:attached_files] = {}    
    # New attached files
    new_files = study.attached_files.select(&:new_record?)
    if new_files.any?
      @data[:attached_files][:new] = add_files_strings(new_files)
    end
    
    # Changes to attached files
    study.attached_files.map do |file|
      if !file.new_record? && file.changes.include?('notes')
        string = change_strings({ 'notes' => file.changes['notes'] })
        @data[:attached_files][file.id] = string unless string.blank?
      end
    end
    
    # Removed attached_files
    deleted_files = study.attached_files.select(&:frozen?)
    if deleted_files.any?
      @data[:attached_files][:deleted] = removed_files_strings(deleted_files)
    end
    
    # Clean up if no changes.
    @data.delete(:attached_files) if @data[:attached_files].blank?
    
    if @data.any?
      event = study.events.build(
        :user_id => study.user_id,
        :data    => @data,
        :title   => ['study', study.title] )
    end
    
  end
  
  def before_destroy(study)
    # Currently, I can't think of a way of implementing this,
    # as how can you attach an event to a record that you're about
    # to destroy? Even if you mark it not to be deleted, and 
    # over-write the :dependent => :destroy behaviour, you then
    # have no way of finding it - it's been orphaned.
    # I suppose I could overwrite the destroy behaviour to nullify
    # it instead.
  end
  
  private
  
  def add_files_strings(files)
    files.map { |file| "'#{file.document_file_name}' was added." }
  end
  
  def removed_files_strings(files)
    files.map do |file|
      # Paperclip removes this attribute.
      name = "#{file.changes["document_file_name"].first}"
      name = name.blank? ? 'An attached_file' : "'#{name}'"
      "#{name} was deleted."
    end
  end
  
  def change_strings(changes)
    verbose = changes.length == 1 && changes.values.first.all? do |value|
      value.is_a?(String) ? value.length < 50 : false
    end
    
    if verbose
      removed = changes.values.first.first.strip
      added   = changes.values.first.last.strip      
      
      "The #{changes.keys.first} changed from '#{removed}' to '#{added}'."
    else
      keys = changes.keys.map { |key| key =~ /(.*)_id$/ ? $1 : key }
      "The #{keys.to_sentence} #{was_or_were(changes.keys)} updated."
    end    
  end

end