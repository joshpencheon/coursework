class JavascriptsController < ApplicationController
  def attached_file_form
    render :partial => "attached_files/new_attached_file.html.erb", :object => AttachedFile.new
  end
end
