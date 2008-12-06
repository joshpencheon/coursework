module LayoutHelper
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  # Loads partial into <head>, wrapping it in 
  # <script> tags and a jQuery dom:loaded statement
  def require_jquery(partial_path)
    if partial_path.is_a?(Array) 
      partial_path.collect{ |path| require_jquery(path) }
    else
      js = "$(document).ready(function(){" + render(:partial => 'javascripts/' + partial_path + '.js.erb') + "});"
      content_for(:head) { javascript_tag { js }}
    end
  end
  
  # Puts any enclosed javascript into the <head> of the document, 
  # wrapping it in <script> tags and a jQuery dom:loaded statement  
  def jquery_block(&block)
    js = "$(document).ready(function(){" + capture(&block) + "});"
    content_for(:head) { javascript_tag { concat js, block.binding } }
  end
  
  def menu_link(name, path, options = {})
    current = (path =~ %r(#{controller.controller_name})) ? {:class => 'current'} : {}
    link_to name, path, options.merge(current)
  end 
  
  def jquery_link(name, options = {})
    content_tag :a, name, options.merge({:href => 'javascript:;'})
  end
  
  def icon(name, options = {})
    options[:class] ||= ''
    options[:class] += ' icon'
    image_tag "icons/#{name}", options
  end
end