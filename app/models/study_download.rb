require 'fileutils'
require 'prawn'

class StudyDownload
  attr_accessor :study_id, :format, :comments, :token
  
  def self.destroy_all
    FileUtils.remove_dir containing_dir
    FileUtils.mkdir containing_dir
  end
  
  def self.serve(identifier)
    begin
      Dir.chdir(containing_dir) do
        File.expand_path(Dir.glob("#{identifier}.???")[0])
      end
    rescue Exception => e
      raise ActiveRecord::RecordNotFound, 'Unable to find archive ' + identifier
    end
  end
  
  def initialize(options = {})
    begin
      log('starting new bundle...')
      
      @study_id = options[:id]
	    @format   = options[:archive_format].blank? ? 'zip' : options[:archive_format].to_s.downcase
	    @comments = options[:include_comments] || false
	    @token    = options[:token] || ActiveSupport::SecureRandom.hex(16)  	    	    
	    
	    unless get_study
	      raise 'Unable to find Study'
	    end
	    
	    if build_directory
	      populate_directory
	    end
	    
	    compress!
	    
	    log('completed bundle successfully!')
    rescue Exception => e
      log('Error: ' + e)
      log("called with (#{options.class}): " + options.inspect)
      e.backtrace.each { |line| log(line) }
      FileUtils.remove_dir @temp_dir if @temp_dir
    end
  end
  
  private
  
  def compress!
    Dir.chdir(self.class.containing_dir) do
      log('compressing download...')
      
      # Rename for archive contents
      unique = "#{@study.to_param}_#{Time.now.to_i}"
      `mv #{token_string} #{unique}`
      
      if @format == 'zip'
        `zip -r #{token_string}.zip #{unique}`
      elsif @format == 'tgz'
        `tar -cvzf #{token_string}.tgz #{unique}`
      else
        raise 'Unknown compression format: ' + @format
      end
    
      log('cleaning up...')
      # Leave only the archive
      FileUtils.remove_dir unique
    end
  end
  
  def get_study
    @study = Study.find_by_id(@study_id)
  end
  
  def token_string
    "#@study_id-#@token"
  end
  
  def build_directory
    path = File.join(self.class.containing_dir, token_string)
    @temp_dir = FileUtils.mkdir_p(path)
  end
  
  def populate_directory
    if @study.attached_files.any?
      attachment_dir = FileUtils.mkdir_p(File.join(@temp_dir, 'attachments'))
      log("copying attachments to '#{attachment_dir}'")
      
      @study.attached_files.each do |file|
        src = File.join(Rails.public_path, file.document.url)
        FileUtils.cp src, attachment_dir
      end
    end
    
    create_summary_pdf
    if @comments
      create_watchers_pdf
      create_comments_pdf 
    end
  end
  
  def create_comments_pdf
    file_name = "Comments.pdf"
    log("building #{file_name}")
    
    watchers = Prawn::Document.new(file_name) do |pdf|
      pdf.header pdf.margin_box.top_left do
        pdf.text "Comments on '#{@study.title}'", :size => 24, :align => :center
        pdf.stroke_horizontal_rule
      end
      
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 50],
          :width => pdf.bounds.width, :height => pdf.bounds.height - 100) do
      
        pdf.pad(4) do
          pdf.text 'This document contains all the comments made on the study.'
        end
      
        @study.comments.each do |comment|
          pdf.pad(4) do
            author = comment.user.name
            author += " (#{comment.user.email})" unless comment.user.email_hidden?
            pdf.text "By: #{author} - #{comment.created_at.to_s(:long)}" 
            
            pdf.pad(1) do
              pdf.text comment.content, :size => 10
            end       
          end          
        end
      end
    end
    
    watchers.render_file(File.join(@temp_dir, file_name))
  end
  
  def create_watchers_pdf
    file_name = "Watchers.pdf"
    log("building #{file_name}")
    
    watchers = Prawn::Document.new(file_name) do |pdf|
      pdf.header pdf.margin_box.top_left do
        pdf.text "Watchers of '#{@study.title}'", :size => 24, :align => :center
        pdf.stroke_horizontal_rule
      end
      
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 50],
          :width => pdf.bounds.width, :height => pdf.bounds.height - 100) do
      
        pdf.pad(4) do
          pdf.text 'This document contains the names of all those who are watching this study.'
        end
      
        @study.watchers.each do |watcher|
          pdf.pad(4) do
            text = watcher.name
            text += " (#{watcher.email})" unless watcher.email_hidden?
            pdf.text text        
          end          
        end
      end
    end
    
    watchers.render_file(File.join(@temp_dir, file_name))
  end
  
  def create_summary_pdf
    file_name = "Summary.pdf"
    log("building #{file_name}")
    
    summary = Prawn::Document.new(file_name) do |pdf|
      pdf.header pdf.margin_box.top_left do
        pdf.text @study.title, :size => 24, :align => :center
        pdf.stroke_horizontal_rule
      end
      
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 50],
          :width => pdf.bounds.width, :height => pdf.bounds.height - 100) do
      
        pdf.pad(4) do
          author = 'By: ' + @study.user.name
          author += " (#{@study.user.email})" unless @study.user.email_hidden?
          pdf.text author, :size => 16          
        end
        
        pdf.pad(4) do
          pdf.text "Originally posted: #{@study.created_at.to_s(:long)}"
          pdf.text "Last updated: #{@study.updated_at.to_s(:long)}"
        end
        
        pdf.pad(4) do
          pdf.text "Region: #{@study.region.name}"
          pdf.text "Partnership: #{@study.partnership.name}"
        end
        
        pdf.pad_top(8) do
          pdf.text 'Summary:', :size => 16
          description = @study.description.blank? ? 'No Description Available' : @study.description
          pdf.text description      
        end
      end
    end
    
    summary.render_file(File.join(@temp_dir, file_name))
  end
  
  def log(message)
    Study.logger.info("[downloader] " + message)
  end
  
  def self.containing_dir
    File.join(Rails.public_path, 'study_downloads')
  end
end