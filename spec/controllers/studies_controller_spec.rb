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
    
    it '#edit should render a form populated with the study' do
      get 'edit', :id => Study.first
      
      assigns[:study].should_not be_new_record
    end
    
    context 'and updating a study' do
      before(:each) do
        @study = Study.first
        @study.update_attribute(:user_id, current_user.id)
      end
      
      it '#update should re-save a valid study and redirect to it' do
        put 'update', :id => Study.first, :study => @study.attributes
        response.should redirect_to(study_path(assigns[:study]))
      end
      
      it 'should not create events if the author != the editor'
      
      it 'should add attached_files attributes if not present'
    end
  end

end