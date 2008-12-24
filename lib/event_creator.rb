class EventCreator
  # Need this for the pluralize method & links.
  
  def before_save(model, user = :user, title = :title)
    user = model.send(user)
    model_string = model.class.to_s.downcase
    
    @event = model.events.build(:title => "#{model.class.to_s.downcase} '#{model.send(title)}'", :data => [])
    
    model.changes_by_type.each_pair do |assoc, changeset|
      singular_name = assoc.to_s.humanize.downcase.singularize
      
      if assoc == :self
        # "The study had it's title and description updated."
        @event.data << 
          { :edited => "The #{model_string} had its #{changeset.keys.to_sentence} updated." }
        
      else
        if changeset.key?(:new)
          # "4 attached files were added to the study"
          join = was_or_were(changeset[:new])
          @event.data << 
            { :new => "#{helpers.pluralize(changeset[:new].length, singular_name)} #{join} added to the #{model_string}." }
        
        elsif changeset.key?(:edited)
          # "One of the study's attached files had it's title updated"
          changeset[:edited].each do |record, changes|
            @event.data << 
              { :edited => "One of the #{model_string}'s #{singular_name.pluralize} had its #{changes.keys.to_sentence} updated." }            
          end
  
        elsif changeset.key?(:deleted)
          # "1 attached file was deleted from the study."
          join = was_or_were(changeset[:deleted])
          @event.data << 
            { :deleted => "#{helpers.pluralize(changeset[:deleted].length, singular_name)} #{join} removed from the #{model_string}." }
        end        
      end
      
    end
  end
  
  def before_destroy(model)
    # Currently, I can't think of a way of implementing this,
    # as how can you attach an event to a record that you're about
    # to destroy? Even if you mark it not to be deleted, and 
    # over-write the :dependent => :destroy behaviour, you then
    # have no way of finding it - it's been orphaned.
  end
  
  private 
  
  def helpers
    ActionController::Base.helpers
  end
  
  def was_or_were(array)
    array.length == 1 ? 'was' : 'were'
  end
  
end