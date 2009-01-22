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
    @study = Study.find(params[:study_id])
  end

end
