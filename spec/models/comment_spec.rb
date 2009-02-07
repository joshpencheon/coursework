require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  context 'without any content' do
    it 'should not be valid' do
      @comment = Comment.new
      @comment.should_not be_valid
    end
  end
  
  context 'with a comment and a study' do
    it 'should be valid' do
      attributes = { :content => 'hihi', :study => Study.valid.create! }
      proc { @comment = Comment.create!(attributes) }.should_not raise_error
      @comment.should_not be_new_record
    end
  end
end