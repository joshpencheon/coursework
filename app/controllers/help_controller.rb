class HelpController < ApplicationController

  before_filter :get_partial, :except => [ :search ]

  def search 
    render :text => "some search results: #{params[:search]}"
  end

  def index
  end
  
  def welcome
  end
  
  def private_details
  end
  
  private
  
  def get_partial
    topic = params[:topic].blank? ? 'index' : params[:topic]
    render :partial => topic + '.html.erb'    
  end
end
