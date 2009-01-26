class DownloadsController < ApplicationController
  before_filter :find_study, :only => [:configure, :build, :serve]

  def configure
    render :partial => 'configure.html.erb' if request.xhr?
  end

  def build
    @reference_token = ActiveSupport::SecureRandom.hex(16) 
    params[:token] = @reference_token
    StudyDownload.new(params)

    redirect_to serve_download_path(:id => "#{@study.id}-#@reference_token")
  end

  def serve
    send_file StudyDownload.serve(params[:id]), :filename => "sdu_archive_#{@study.to_param}"
  end

  private
  
  def find_study
    unless @study = Study.find_by_id(params[:id])
      flash[:warn] = "Study could not be found"
      redirect_to studies_url
    end
  end

end
