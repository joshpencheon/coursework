require File.dirname(__FILE__) + '/../spec_helper'

describe Study do
  context 'when making a filtered search' do
    it 'should include filters if they are specified'
    
    it 'should ignore blank filters'
  end
  
  context 'freshly initialized' do
    before(:each) do
      @study = Study.new
    end
  
    it 'should define a #publish_event= method' do
      @study.method_exists?(:publish_event=).should be_true
    end
  
    it 'should publish events unless specifically set not to' do
      @study.publish_event.should be_true
      @study.publish_event = nil    
      @study.publish_event.should be_true
      @study.publish_event = false
      @study.publish_event.should be_false 
    end
    
    it 'should return the default for a thumbnail' do
      @study.thumbnail_url.should == "/images/default_study.png"
    end
    
    context 'when tagging' do
      it 'should accept new tags' do
        @study.tag_list = ['some', 'nice', 'tags']
      end
    end
  end
  
  context 'with valid attributes' do
    before(:each) do
      @study = Study.valid.new
    end
    
    it 'should be valid' do
      @study.should be_valid
    end
        
    [ :title, :description, :category, :partnership_id, :region_id].each do |attr|
      it "it should become invalid if the #{attr} attr is removed" do
        @study.send("#{attr}=", nil)
        @study.should_not be_valid
      end
    end
    
    it 'should become invalid with a title over 40 characters' do
      @study.title = 'a'*41
      @study.should_not be_valid
    end
    
    context 'but with category present but incorrect' do
      it 'should not be valid' do
        @study.category = 'Not_A_Read_Category'
        @study.should_not be_valid
        @study.errors.on(:category).should_not be_empty
      end
    end
    
    context 'and unsaved attachments' do
      before(:each) do
        @fixture = File.open(File.join(RAILS_ROOT, 'spec', 'fixtures', 'text.txt'))
      end
      
      it 'should save them when saved' do
        length = @study.attached_files.length
        @study.attached_files.build({ :document => @fixture })
        @study.save!
        @study.attached_files.length.should == length + 1
      end
      
      it 'should save them via params hash when saved' do
        params = {:new_attached_file_attributes => [{ :document => @fixture }]}
        proc { @study.update_attributes!(params) }.should change(@study.attached_files, :length).by(1)
      end
      
      it 'should not save if they are not valid but have been changed' do
        @study.attached_files.build({:document => nil, :notes => 'it is no good.'})
        @study.attached_files.first.should_not be_valid
        
        @study.save
        @study.should be_new_record
      end
      
      it 'should remove any untouched attachments and save itself' do
        @study.attached_files.build
        @study.attached_files.first.untouched?.should be_true

        @study.save
        @study.should_not be_new_record
      end
    end
    
    context 'before saving' do
      it 'should not build an event if a new record?' do
        @study.should be_new_record
        @study.save!
        @study.events.length.should be_zero
      end
      
      it 'should not build an event if it is not valid' do
        @study.title = nil
        @study.save
        @study.events.length.should be_zero
      end
      
      context '(not for the first time)' do
        before(:each) do
          @study.save!
          @study.should_not be_new_record
        end
        
        it 'should note build an event if there have not been any changes' do
          @study.save!
          @study.events.length.should be_zero          
        end
        
        it 'should build an event if there have been changes' do
          @study.title = 'a changed title'
          @study.save!
          @study.events.length.should_not be_zero
        end        
      end
    end
  end
  
  context 'once saved' do
    before(:each) do 
      @study = Study.valid.create
    end
    
    context 'with already-saved attached files' do
      before(:each) do
        @attached_file = @study.attached_files.text.create
      end
      
      it 'should update them when it is saved' do
        @attached_file.notes = 'some new notes'
        @study.save!    
        @attached_file.reload.notes.should == 'some new notes'
      end
      
      it 'should update them via params when it is saved' do
        params = {:existing_attached_file_attributes => { @attached_file.id.to_s => {:notes => 'some new notes'} }}
        @study.reload.update_attributes!(params)    
        @attached_file.reload.notes.should == 'some new notes'
      end
      
      it 'should not update the notes if they are blank in both object and params' do
        blank_notes = { :notes => '' }
        @attached_file.update_attributes!(blank_notes)
        proc {
          @study.existing_attached_file_attributes = { @attached_file.id.to_s => blank_notes }
        }.should_not change(@attached_file, :notes_changed?).from(false).to(true)
      end
      
      it 'should remove them if they are not present in params' do
        @study.attached_files << AttachedFile.text.new
        @study.attached_files.first.should_not be_new_record
        @study.reload.update_attributes!({:existing_attached_file_attributes => {} })
        @study.attached_files.reload.should be_empty
      end
      
    end
    
    context 'when formatted for URLs' do
      before(:each) do
        @study.id = 4
      end
      
      it 'should combine id and title' do
        @study.title = 'my fun title'
        @study.to_param.should == '4-my-fun-title'
      end
      
      it 'should convert the title to lower case' do
        @study.title = 'MY LOUD TITLE'
        @study.to_param.should == '4-my-loud-title'
      end
      
      it 'should remove illegal characters from and strip the title' do
        @study.title = ' _    123.lalalalal?      '
        @study.to_param.should == '4-lalalalal'
      end
    end
    
    context 'with both saved and unsaved attached files' do
      before(:each) do
        @study.attached_files.text.create
        @study.attached_files.image.create
        @study.attached_files.build
      end
      
      it 'should return unsaved attachments separately' do
        @study.unsaved_attachments.length.should == 1
      end
         
      it 'should sort saved attachments images first' do
        @study.saved_attachments.length.should == 2
        @study.saved_attachments.first.should be_image
      end 
      
      it 'should not miss any out when separating' do
        combined = [@study.saved_attachments + @study.unsaved_attachments].flatten
        @study.attached_files.should =~ combined
      end
    end
    
    context 'with users watching it' do
      before(:each) do
        3.times do
          Watching.toggle(@study, User.valid.create!)
        end
      end

      it 'should return them in an array' do
        @study.watchers.length.should == 3
      end
      
      it 'should return them without given users correctly' do
        a_watcher = @study.watchers.first
        other_watchers = @study.watchers[-2, 2]
        @study.watchers_other_than(a_watcher).should =~ other_watchers
        [a_watcher, other_watchers].flatten.should =~ @study.watchers
      end
      
      context 'when #watched by is called' do
        it 'should return true for users who are watching' do
          @study.watchers.each do |watcher|
            @study.watched_by?(watcher).should be_true
          end          
        end
        
        it 'should return false for users who are not watching' do
          @study.watched_by?(User.valid.create!).should be_false
        end
      end
      
    end
  end
end