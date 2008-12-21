class EventCreator
  
  def before_save(model)
    model.changes_by_type.each_pair do |assoc, changeset|
      
      if assoc == :self
        model.events.build(:description => "The #{model.class.to_s.downcase} had it's #{model.changed.to_sentence} updated.")
      else
        if changeset.key?(:new)
           model.events.build(:description => 
             "A new #{assoc.to_s.humanize.downcase} was added to the #{model.class.to_s.downcase}.")
        elsif changeset.key?(:edited)
          model.events.build(:description => 
            "One of the #{model.class.to_s.downcase}'s #{assoc.to_s.humanize.downcase} was updated.")        
        elsif changeset.key?(:deleted)
          model.events.build(:description => 
            "A #{assoc.to_s.humanize.downcase} was deleted from the #{model.class.to_s.downcase}.")
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
  
end