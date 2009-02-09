require File.dirname(__FILE__) + '/../spec_helper'

describe StudiesController do
  
  it '#index should list all the studies, most recent first' do
    get 'index'
    
    assigns[:studies].should_not be_nil
    assigns[:studies].first.should be_a_kind_of(Study)    
    response.should render_template('index')
  end
  
  it '#search should return studies matching params' do
    Study.stubs(:filtered_search).returns(Study.all(:limit => 2))
    get 'search'
    
    assigns[:searching].should be_true
    assigns[:studies].length.should == 2  
    response.should render_template('index')
  end
  
  it '#tag should return all studies tagged with the given tag' do
    tag = Tag.first
    get 'tag', :id => tag
    
    length = assigns[:studies].select { |study| study.tag_list.include?(tag.name) }.length
    length.should equal(assigns[:studies].length)
    assigns[:title].should_not be_nil
    response.should render_template('index')
  end
  
  it '#show should display a single study' do
    get 'show', :id => Study.first
    
    assigns[:study].should_not be_nil
    response.should render_template('show')
  end
  
  context 'when logged in as a regular user' do
    before(:each) do
      login
      current_user.stubs(:admin?).returns(false)
    end
    
    it '#new should initialize a new study object' do
      get 'new'
    
      assigns[:study].should be_new_record
      response.should render_template('new')
    end
    
    context 'and creating a study' do
      it '#create should save a valid study and redirect to it' do
        post 'create', :study => Study.valid.new.attributes
        
        assigns[:study].should be_valid
        flash[:notice].should_not be_nil
        response.should redirect_to(study_path(assigns[:study]))
        
      end
      
      it '#create should render the #new template if the study is not valid' do
        post 'create', :study => Study.new.attributes
        
        assigns[:study].should_not be_nil
        flash[:notice].should be_nil
        response.should render_template('new')
      end
    end
        
    context 'when working with a study that is not theirs' do
      before(:each) do
        @study = Study.valid.create!
      end
      
      it 'they should not be able to edit it' do
        get 'edit', :id => @study
        response.should redirect_to(study_path(assigns[:study]))
      end

      it 'they should not be able to update it' do
        put 'update', :id => @study
        response.should redirect_to(study_path(assigns[:study]))
      end
    
      it 'they should not be able to delete it' do
        delete 'destroy', :id => @study
        response.should redirect_to(study_path(assigns[:study]))
      end
    end
    
    context 'and working with a saved study belonging to them' do
      before(:each) do
        @study = Study.first
        @study.update_attribute(:user_id, current_user.id)
      end
      
      it '#edit should render a form populated with the study' do
        get 'edit', :id => @study

        assigns[:study].should_not be_new_record
        response.should render_template('edit')
      end
      
      it '#update should re-save a valid study and redirect to it' do
        put 'update', :id => @study, :study => @study.attributes
        response.should redirect_to(study_path(assigns[:study]))
      end
      
      it '#update should remove attached_files not present (default value of :existing_attached_file_attributes)' do
        @study.attached_files.destroy_all
        @study.attached_files << AttachedFile.text.create!
        put 'update', :id => @study, :study => { :existing_attached_file_attributes => {} }
        assigns[:study].reload.attached_files.length.should == 0
      end
      
      it '#destroy should delete the study, attached files, events, watchings and comments' do
        assoc = @study.attached_files + @study.events + @study.watchings + @study.comments
        delete 'destroy', :id => @study
        assoc.each { |obj| obj.class.exists?(obj.id).should be_false }
        response.should redirect_to(studies_url) 
      end
    end
  end

end