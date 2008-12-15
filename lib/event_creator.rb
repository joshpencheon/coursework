class EventCreator
   # def initialize(*associations)
   #   @associations = associations.map { |assoc| assoc.to_s.pluralize.to_sym }.flatten
   # end
   # 
   # def before_save(object)
   #   @object = object
   #   
   #   # Cache the changes to other records
   #   # before they're saved too.
   #   store_associated_record_changes 
   # end
   #   
   # # Checking for changes stops Events being created for
   # # saves when the record wasn't touched, and prevents
   # # looping for existing records because of the
   # # polymorphic save settings.
   # def after_save(object)
   #   @object = object
   #   
   #   @conditions_for_creation = { 
   #     :default => object.changed?,
   #     :attr_changes => object.changes.any? }
   #     
   #   if associated_record_changes
   #     @conditions_for_creation.merge!({
   #       :associated_changes   => associated_record_changes.any?,
   #       :associated_deletions => associated_record_deletions.any?
   #     })
   #   end
   #   
   #   if @conditions_for_creation.values.any?      
   #     event = Event.new(:description => event_message)
   #     event.news_item = object
   #     event.save!
   #   end
   # end
   # 
   # private
   # 
   # def event_message
   #   method_name = :"event_message_for_#{@object.class.to_s.downcase}"
   #   self.respond_to?(method_name, true) ? self.send(method_name) : "Some default message."
   # end
   # 
   # def event_message_for_study
   #   message = ''
   #   
   #   if @conditions_for_creation[:associated_deletions]
   #     message << "#{associated_record_deletions.length} file(s) were deleted from Study."
   #   end
   #   
   #   if @conditions_for_creation[:associated_changes]
   #     changes = associated_record_changes.delete_if { |k, v| k == :snapshot }
   #     
   #     if changes.any?
   #       message << 'Study files updated with: ' << changes.inspect << '.'
   #     end
   #   end
   #   
   #   if @conditions_for_creation[:attr_changes]
   #     message << "Study's #{changed_attributes_sentence} updated."
   #   end
   #   
   #   if message.blank?
   #     message << 'Study updated'
   #   end 
   #   
   #   message   
   # end
   # 
   # def event_message_for_user
   #   'User updated.'
   # end
   # 
   # def changed_attributes_sentence
   #   (@object.changed - ["created_at", "updated_at"]).reject do |attribute|
   #     attribute =~ /_id&/
   #   end.to_sentence
   # end
   # 
   # def store_associated_record_changes
   #   # Taking a snapshot allows detection of deletion.
   #   changes = { :snapshot => associated_records_snapshot }
   #   
   #   if associated_records_changed?
   #     changed_associated_records.each do |record|
   #       key = record.class.to_s
   #       changes[key] ||= {:new => []}
   #       if record.id
   #         changes[key][record.id] = record.changes 
   #       else
   #         changes[key][:new] << record.changes
   #       end
   #     end
   #   end
   #   
   #   @object.dumped_event_data = changes
   # end
   # 
   # def associated_record_changes
   #   @object.dumped_event_data || {}
   # end
   # 
   # def associated_record_deletions 
   #   @force_reload = true
   #   deletions = associated_record_changes[:snapshot] - associated_records_snapshot
   #   puts '','DELETIONS:',deletions.inspect
   #   deletions
   # end
   # 
   # def changed_associated_records
   #   associated_records.select(&:changed?)
   # end
   # 
   # def associated_records_changed?
   #   changed_associated_records.any?
   # end
   # 
   # def associated_records_snapshot
   #   associated_records.map do |record|
   #     [record.class.to_s, record.id]
   #   end
   # end
   # 
   # def associated_records
   #   associated = @associations.map { |assoc| @object.send(assoc, @force_reload) }.flatten
   #   @force_reload = false #one-time
   #   associated
   # end
end