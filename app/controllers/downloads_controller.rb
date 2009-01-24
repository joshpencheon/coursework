class DownloadsController < ApplicationController
  before_filter :find_study, :only => :serve

  def configure
    render :partial => 'configure.html.erb' if request.xhr?
  end

  def build
    spawn do 
      StudyDownload.new(params[:study_download])
    end
  end

  def serve
    send_data StudyDownload.serve('...'),
      :filename => @study.title
  end

  private
  
  def find_study
    unless @study = Study.find_by_id(params[:id])
      flash[:warn] = "Study could not be found"
      redirect_to studies_url
    end
  end

end
