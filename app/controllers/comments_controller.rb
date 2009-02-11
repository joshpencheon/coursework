class CommentsController < ApplicationController
  before_filter :authorize
  before_filter :find_study, :only => [ :create ]

  def create
    @comment = @study.comments.build(params[:comment])
    @comment.user_id = current_user.id
    @comment.save
  end
  
  private
  
  def find_study
    unless @study = Study.find_by_id(params[:study_id])
      flash[:warn] = 'That study could not be found'
      redirect_to studies_url
    end
  end

end
