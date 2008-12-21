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
  # This should only be used on special occasions - normally,
  # custom jQuery should be added to the behaviours.js
  def require_jquery(partial_path)
    if partial_path.is_a?(Array) 
      partial_path.collect{ |path| require_jquery(path) }
    else
      partial = render(:partial => 'javascripts/' + partial_path + '.js.erb')
      content_for(:head) { javascript_tag { "$(document).ready(function(){#{partial}});" } }
    end
  end
  
  def sidebar_action(*args)
    @sidebar_action ||= []
    @sidebar_action << content_tag(:li, link_to(*args))
  end
  
  def menu_link(name, path, options = {})
    current = (path =~ %r(#{controller.controller_name})) ? {:class => 'current'} : {}
    link_to name, path, options.merge(current)
  end 
  
  # TODO: Remove - this is bad as it doesn't allow for a fallback behaviour.
  def jquery_link(name, options = {})
    content_tag :a, name, options.merge({:href => 'javascript:;'})
  end
  
  def icon(name, options = {})
    options[:class] ||= ''
    options[:class] += ' icon'
    image_tag "icons/#{name}", options
  end
end