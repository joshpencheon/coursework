require File.dirname(__FILE__) + '/../spec_helper'

describe AttachedFile do
  def path_to_file(filename)
    File.join(fixture_path, filename)
  end
  
  context 'with a document' do
    before(:each) do
      @attached_file = AttachedFile.new
      @attached_file.document = File.open(path_to_file('text.txt'))
    end
  
    it "should be valid" do
      @attached_file.should be_valid
    end  
  end
  
end