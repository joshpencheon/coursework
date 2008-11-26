require File.dirname(__FILE__) + '/../spec_helper'

describe 'A String' do
  context 'when #capitalize_name is called' do
    it "should capitalize and format each word" do
      '   john mcdonald'.capitalize_name.should == 'John McDonald'
      "   billy o'reilly   ".capitalize_name.should == "Billy O'Reilly"
    end
  end
end 