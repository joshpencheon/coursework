class AttachedFilesController < ApplicationController  
  before_filter :find_attached_file, :only => [ :show ]
  
  def show
    disposition = @attached_file.displayable_inline? ? 'inline' : 'attachment'
    
    send_file @attached_file.document.url, 
      :type        => @attached_file.document_content_type,
      :disposition => disposition
  end
  
  private
  
  def find_attached_file
    @attached_file = AttachedFile.find(params[:id])
  end

end
