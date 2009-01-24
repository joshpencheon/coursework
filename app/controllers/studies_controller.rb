class StudiesController < ApplicationController
  before_filter :find_study, :only  => [ :show, :watch, :unwatch, :edit, :update, :destroy ]
  before_filter :authorize, :except => [ :index, :show ]
  
  def index
    @studies = Study.find_by_category(params[:category]) || Study.all
  end

  def show
  
  end

  def watch
    Watching.toggle(@study, current_user)
    
    respond_to do |format|
      format.html { redirect_to @study }
      format.js   # Render the relevant template.
    end
  end
  
  def new
    @study = current_user.studies.new
  end
  
  def create
    @study = current_user.studies.new(params[:study])
    if @study.save
      flash[:notice] = "Successfully created..."
      redirect_to @study
    else
      render :action => "new"
    end
  end

  def edit
    
  end
  
  def update  
    params[:study][:existing_attached_file_attributes] ||= {}
    params[:study][:publish_event] = false unless current_user.id == @study.user.id
    
    if @study.update_attributes(params[:study])
      flash[:notice] = "Successfully updated..."
      redirect_to @study
    else
      render :action => "edit"
    end
  end

  def destroy
    @study.destroy
    redirect_to studies_path
  end
  
  private
  
  def find_study
    unless @study = Study.find_by_id(params[:id])
      flash[:warn] = "Unable to find study."
      redirect_to studies_url
    end
  end
  
  def authorize
    unless can_edit?(@study)
      flash[:warn] = 'You cannot access that page.'
      redirect_to @study
    end
  end
end
