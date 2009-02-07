module FaceboxHelper
  
  # Returns a boolean as to whether the user should be shown
  # the inital introduction message upon logging in for the first time.
  def show_welcome_message?
    session[:welcome?] && current_user.login_count == 1
  end
  
  # Generate necessary link to call facebox.
  # 
  # link_to_facebox('click for image', :image => 'rails.png', :id => 'logo')  
  #   # => <a href="rails.png" id="logo" rel="facebox">click for image</a> 
  # 
  # link_to_facebox('click for T&Cs', :div => 'terms_and_conditions', :class => 'boring-font')  
  #   # => <a href="#terms_and_conditions" rel="facebox[.boring-font]">click for T&Cs</a>  
  # 
  # link_to_facebox('click for latest news', :ajax => news_path)  
  #   # => <a href="/news" rel="facebox">click for latest news</a> 
  # 
  # link_to_facebox('click for message', :text => 'hello, world!', :class => 'simple')
  #   # => <a href="javascript:void(0);" onclick="jQuery.facebox('hello, world!', 'simple')">click for message</a>
  #
  def link_to_facebox(text, options)
    if options.has_key?(:text)
      js = "jQuery.facebox('"
      js += escape_javascript(options.delete(:text)) + "'"
      if options.has_key?(:class)
        js += ", '#{options.delete(:class)}'"
      end
      js += ')'
      options[:onclick] = js
      link_to(text, 'javascript:void(0);', options)
    else
      href = if options.has_key?(:div)
        "##{options.delete(:div)}"
      elsif options.has_key?(:image)
        image_path(options.delete(:image)).gsub(/\?(\d)*/, '')
      elsif options.has_key?(:ajax)
        options.delete(:ajax)
      end
      options[:rel] = 'facebox'
      options[:rel] += ".#{options.delete(:class)}" if options.has_key?(:class)
      link_to(text, href, options)
    end
  end
  
end