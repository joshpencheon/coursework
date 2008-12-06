require File.dirname(__FILE__) + '/../spec_helper'

describe AttachedFile do
  def path_to_file(filename)
    File.dirname(__FILE__) + "/../fixtures/#{filename}"    
  end
  
  def path_to_file_of_type(type)
    basename, extension = AttachedFile::ALLOWED_CONTENT_TYPES.detect{ |b,e| e == type }
    path_to_file("#{basename.gsub(/\s/,'').downcase}.#{extension}")
  end
  
  context "in general" do
    before(:each) do
      @attached_file = AttachedFile.new(:document => File.open(path_to_file_of_type('txt')) )
    end
  
    it "should have an attachment" do
      @attached_file.should be_valid
    end
  
    it "should be invalid without an attachment" do
      @attached_file.document = nil
      @attached_file.should_not be_valid
    end
  end
  
  context "when validating content type" do
    AttachedFile::ALLOWED_CONTENT_TYPES.each do |name, ext|
      it "should allow #{name} documents" do
        attached_file = AttachedFile.new( :document => File.new(path_to_file_of_type(ext)) )
        attached_file.should be_valid
      end
    end
    
    %w( ruby.rb bash.sh hax.exe ).each do |filename|
      context "an invalid content type (#{filename})" do
        before(:each) do
          @attached_file = AttachedFile.new(:document => File.new(path_to_file(filename)) )          
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
  
  %w( png gif jpeg ).each do |filename|
    context "when displaying a file of type #{filename}" do
      before(:each) do
        @attached_file = AttachedFile.new(:document => File.new(path_to_file("#{filename}.#{filename}")))
      end
      
      it "should be an image" do
        @attached_file.should be_image
      end
      
      it "should be displayable_inline" do
        @attached_file.should be_displayable_inline
      end
      
      it "should not be hazardous" do
        @attached_file.should_not be_hazard
      end
    end
  end
  
  context "when plain text" do
    before(:each) do
      @attached_file = AttachedFile.new(:document => File.new(path_to_file_of_type('txt')))
    end
      
    it "should not be an image" do
      @attached_file.should_not be_image
    end
    
    it "should be displayable_inline" do
      @attached_file.should be_displayable_inline
    end
    
    it "should not be hazardous" do
      @attached_file.should_not be_hazard
    end
  end
  
  context "when a zip archive" do
    before(:each) do
      @attached_file = AttachedFile.new(:document => File.new(path_to_file_of_type('zip')))
    end
      
    it "should not be an image" do
      @attached_file.should_not be_image
    end
    
    it "should not be displayable_inline" do
      @attached_file.should_not be_displayable_inline
    end
    
    it "should be hazardous" do
      @attached_file.should be_hazard
    end
  end
  
  [AttachedFile::ALLOWED_CONTENT_TYPES.values - %w( png gif jpeg txt zip )].flatten.each do |filename|   
    context "when of type #{filename}" do
      before(:each) do
        @attached_file = AttachedFile.new(:document => File.new(path_to_file_of_type(filename)))
      end
      
      it "should not be an image" do
        @attached_file.should_not be_image
      end

      it "should not be displayable_inline" do
        @attached_file.should_not be_displayable_inline
      end

      it "should not be hazardous" do
        @attached_file.should_not be_hazard
      end      
    end
  end
  
end