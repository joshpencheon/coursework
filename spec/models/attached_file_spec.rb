require File.dirname(__FILE__) + '/../spec_helper'

describe AttachedFile do
  context 'with a document' do
    before(:each) do
      @attached_file = AttachedFile.text.new
    end
  
    it "should be valid" do
      @attached_file.should be_valid
    end
    
    context 'when dealing with the document' do
      
      it 'should protect document attributes' do
        @attached_file.update_attributes!({:document_file_name => 'my special name'})
        @attached_file.document_file_name.should_not == 'my special name'
      end
      it 'should return its extension without the dot' do
        @attached_file.extension.should == 'txt'
      end
      
      it 'should truncate a "jpg" extension to "jpeg"' do
        @attached_file.stubs(:document_file_name).returns('file.jpg')
        @attached_file.extension.should == 'jpeg'
      end
      
      it 'should remove a trailing "x" from the extension' do
        @attached_file.stubs(:document_file_name).returns('file.docx')
        @attached_file.extension.should == 'doc'
      end
      
      context 'and giving a file string' do
        it 'should be descriptive for a known file type' do
          @attached_file.file_string.should =~ %r(#{AttachedFile::FILE_TYPES['txt']})
        end
        
        it 'should return nil for an unknown file type' do
          AttachedFile.unusual.new.file_string.should be_nil
        end
      end
      
      [
         # Type        # Example                 # Image?  # Text?  # Inline?  # Hazard?  # Thumbnailable?
       [ 'textual',    AttachedFile.text.new,    false,    true,    true,      false,     false ],
       [ 'an image',   AttachedFile.image.new,   true,     false,   true,      false,     true  ],
       [ 'default',    AttachedFile.excel.new,   false,    false,   false,     false,     false ],
       [ 'an archive', AttachedFile.archive.new, false,    false,   false,     true,      false ]  
      
      ].each do |type, example, image, text, inline, hazard, thumbnailable| 
        context "when #{type}" do
          it 'should respond to #image? correctly' do
            example.image?.should equal(image)
          end

          it 'should respond to #plain_text? correctly' do
            example.plain_text?.should equal(text)
          end

          it 'should respond to #displayable_inline? correctly' do
            example.displayable_inline?.should equal(inline)
          end

          it 'should respond to #hazard? correctly' do
            example.hazard?.should equal(hazard)
          end

          it 'should respond to #thumbnailable? correctly' do
            example.thumbnailable?.should equal(thumbnailable)
          end
        end
      end
      
      context 'and returning an icon' do
        it 'should return a specific icon if one can be found' do
          @attached_file.icon_path.should == 'file_txt.png'
        end
        
        it 'should return a default icon if a specific on cannot be found' do
          @attached_file.stubs(:document_file_name).returns('file.pxm')
          @attached_file.icon_path.should == 'file.png'          
        end
      end
      
      context 'returning the title' do
        it 'should return it if the file name exists' do
          @attached_file.title.should == 'text.txt'
        end
        
        it 'should return a default if the file name is nil' do
          @attached_file.document_file_name = nil
          @attached_file.title.should_not be_nil
          @attached_file.title.should == 'untitled'
        end
      end
    end  
  end
  
  context 'without a document' do
    before(:each) do
      @attached_file = AttachedFile.new
    end
    
    it 'should not be valid' do
      @attached_file.should_not be_valid
    end
    
    it 'should not be #untouched? when changes to the notes have been made' do
      @attached_file.notes = 'hihi'
      @attached_file.untouched?.should be_false      
    end
    
    it 'should be #untouched? when freshly intialised' do
      @attached_file.untouched?.should be_true
    end
  end
  
end