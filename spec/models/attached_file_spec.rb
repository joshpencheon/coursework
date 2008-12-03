require File.dirname(__FILE__) + '/../spec_helper'

describe AttachedFile do
  before(:each) do
    path_to_file = File.dirname(__FILE__) + '/../fixtures/dummy_attachment.txt'
    @attached_file = AttachedFile.new(:document => File.open(path_to_file) )
  end
  
  it "should have an attachment" do
    @attached_file.should be_valid
  end
  
  it "should be invalid without an attachment" do
    @attached_file.document = nil
    @attached_file.should_not be_valid
  end
  
  context "when validating content type" do
    AttachedFile::ALLOWED_CONTENT_TYPES.each do |name, ext|
      it "should allow #{name} documents" do
        path_to_file = File.dirname(__FILE__) + "/../fixtures/#{name.gsub(/\s/,'').downcase}.#{ext}"
        attached_file = AttachedFile.new(:document => File.new(path_to_file) )
        attached_file.should be_valid
      end
    end
    
    %w( ruby.rb bash.sh hax.exe ).each do |filename|
      context "an invalid content type (#{filename})" do
        before(:each) do
          path_to_file = File.dirname(__FILE__) + "/../fixtures/#{filename}"
          @attached_file = AttachedFile.new(:document => File.new(path_to_file) )          
        end
        
        it "should be invalid" do
          @attached_file.should_not be_valid
        end
        
        it "should show the correct error message" do
          @attached_file.valid?
          @attached_file.errors.on(:document).should == 'must be: .xls .jpeg .zip .pdf .txt .gif .doc .png .ppt'
        end
      end
    end

  end
  
end