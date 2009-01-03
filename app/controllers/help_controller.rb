class HelpController < ApplicationController
  layout 'basic'

  before_filter :get_partial, :except => [ :search ]

  def search 
    render :text => "some search results: #{params[:search]}"
  end

  def index
  end
  
  private
  
  def get_partial
    topic = params[:topic].blank? ? 'index' : params[:topic]
    @partial = topic + '.html.erb'

    if request.xhr?
      render :partial => @partial
    else
      render :action => 'index'
    end
  end
end
