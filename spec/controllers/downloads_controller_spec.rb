require File.dirname(__FILE__) + '/../spec_helper'

describe DownloadsController do
  context 'when downloading a study' do
    before(:each) do
      @study = Study.valid.create!
    end
    
    it 'should redirect to the listing if the study cannot be found' do
      get 'configure', :id => 'foo'
      flash[:warn].should_not be_nil
      response.should redirect_to(studies_url)
      
    end
    
    context 'and requesting the configuration options' do
      it 'should render the template if the request is not XHR' do
        get 'configure', :id => @study
        response.should render_template('configure')
      end
      
      it 'should return the partial if the request is XHR' do
        xhr :get, 'configure', :id => @study
        response.should render_template('configure')
      end
    end
    
    it '#building should redirect to the download' do
      post 'build', :id => @study
      key = "#{@study.id}-#{assigns[:reference_token]}"
      response.should redirect_to(serve_download_path(:id => key))
    end
    
    it '#serve should return the file from the :id for downloading' do
      file = AttachedFile.image.new
      file.save!
      StudyDownload.stubs(:serve).returns(file.document.path)
      get 'serve', :id => "#{@study.id}-some_hex"
      response.should be_success
    end
  end
end