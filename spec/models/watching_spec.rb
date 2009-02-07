require File.dirname(__FILE__) + '/../spec_helper'

describe Watching do
  before(:each) do
    @study, @user = Study.valid.create!, User.valid.create!
    Watching.toggle(@study, @user)
  end
  
  context 'being created' do
    it 'should link a user and a study' do
      Watching.find_by_study_id_and_user_id(@study, @user).should_not be_nil
    end
  end
  
  context 'being toggled' do
    it 'should not create another Watching' do
      proc { Watching.toggle(@study, @user) }.should_not change(Watching, :count).by(1)
    end
    
    it 'should delete the record if a pairing exists' do
      proc { Watching.toggle(@study, @user) }.should change(Watching, :count).by(-1)
    end
  end
end