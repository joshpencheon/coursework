class AttachedFilesController < ApplicationController

  before_filter :find_study, :except => [ :destroy ]
  before_filter :authorize, :except => [ :index, :show ]  
  before_filter :find_attached_file, :only => [ :show, :edit, :update, :destroy ]
  
  def index
    @attached_files = @study.attached_files
  end
  
  def show
    disposition = @attached_file.displayable_inline? ? 'inline' : 'attachment'
    
    send_file @attached_file.document.url, 
      :type        => @attached_file.document_content_type,
      :disposition => disposition
  end
  
  def new
    @attached_files = @study.attached_files.build
  end
  
  def create
    @study.attached_files.build(params[:attached_file])
    if @study.save
      flash[:notice] = "The attachment was added to the study successfully." 
    end
    redirect_to @study
  end
  
  def destroy
    @attached_file.destroy
    flash[:notice] = "The attachment was deleted successfully."
    redirect_to @attached_file.study
  end
  
  private
  
  def authorize
    can_edit?(@study) ? super : false
  end
  
  def find_study
    @study = Study.find(params[:study_id])
  end
  
  def find_attached_file
    @attached_file = AttachedFile.find(params[:id])
  end

end
