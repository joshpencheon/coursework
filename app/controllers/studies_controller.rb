class StudiesController < ApplicationController
  before_filter :find_study, :only  => [ :show, :watch, :unwatch, :edit, :update, :destroy ]
  before_filter :authorize, :except => [ :index, :show ]
  
  def index
    @studies = Study.all
  end

  def show
  
  end

  def watch
    Watching.link(@study, current_user)
  end

  def unwatch
    Watching.unlink(@study, current_user)
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
    if @study.update_attributes(params[:study])
      flash[:notice] = "Successfully updated..."
      redirect_to @study
    else
      render :action => "new"
    end
  end

  def destroy
    @study.destroy
    redirect_to studies_path
  end
  
  private
  
  def find_study
    @study = Study.find(params[:id])
  end
end
