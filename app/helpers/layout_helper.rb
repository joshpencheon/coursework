module LayoutHelper
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def menu_link(name, path)
    html_options = (path =~ %r(#{controller.controller_name})) ? {:class => 'current'} : nil
    link_to name, path, html_options
  end 
end