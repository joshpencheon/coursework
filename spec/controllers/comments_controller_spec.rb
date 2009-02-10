require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do
  context 'when the user is logged in' do
    before(:each) do
      @study = Study.valid.create!
      login
    end
    
    it "#create should save a comment to the study in question" do
      xhr :post, 'create', :study_id => @study, :comment => { :content => 'my comment' }
      assigns[:comment].should be_a_kind_of(Comment)
      response.should render_template('create.js.erb')
    end
    
    it "#create should redirect to the index if a study can't be found" do
      xhr :post, 'create', :study_id => 'foo', :comment => { :content => 'hehe' }
      flash[:warn].should_not be_nil
      response.should redirect_to(studies_url)
    end
  end
  
  context 'when there is no user logged in' do
    it "should redirect to login page" do
      xhr :post, 'create', :study_id => Study.any_instance, :comment => { :content => 'lalala' }
      flash[:notice].should_not be_nil
      response.should redirect_to(new_user_session_url)
    end
  end
end