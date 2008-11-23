require 'test_helper'

class FaceboxHelperTest < ActionView::TestCase  
  def setup
    ActionController::Routing::Routes.draw do |map|
      map.resources :users
      map.connect ':controller/:action/:id'
    end
  end
  
  def test_link_to_facebox_with_text_without_css_class
    link = link_to_facebox('click for message', :text => 'hello, world!')
    assert_dom_equal %q(<a href="javascript:void(0);" onclick="jQuery.facebox('hello, world!')">click for message</a>), link
  end
  
  def test_link_to_facebox_with_text_with_css_class
    link = link_to_facebox('click for message', :text => 'hello, world!', :class => 'simple')
    assert_dom_equal %q(<a href="javascript:void(0);" onclick="jQuery.facebox('hello, world!', 'simple')">click for message</a>), link
  end
  
  def test_link_to_facebox_with_text_with_css_class_and_mist_attribute
    link = link_to_facebox('click for message', :text => 'hello, world!', :class => 'simple', :id => 'my_link')
    assert_dom_equal %q(<a id="my_link" href="javascript:void(0);" onclick="jQuery.facebox('hello, world!', 'simple')">click for message</a>), link
  end
  
  def test_link_to_facebox_with_image_and_misc_attribute
    link = link_to_facebox('click for image', :image => 'rails.png', :id => 'logo')  
    assert_dom_equal %q(<a href="/images/rails.png" id="logo" rel="facebox">click for image</a>), link
  end
  
  def test_link_to_facebox_with_div_without_css_class
    link = link_to_facebox('click for T&Cs', :div => 'terms_and_conditions')
    assert_dom_equal %q(<a href="#terms_and_conditions" rel="facebox">click for T&Cs</a>), link
  end
  
  def test_link_to_facebox_with_div_with_css_class
    link = link_to_facebox('click for T&Cs', :div => 'terms_and_conditions', :class => 'boring-font')
    assert_dom_equal %q(<a href="#terms_and_conditions" rel="facebox[.boring-font]">click for T&Cs</a>), link
  end
  
  def test_link_to_facebox_with_ajax
    link = link_to_facebox('click for more user info', :ajax => users_path)  
    assert_dom_equal %q(<a href="/users" rel="facebox">click for more user info</a>), link
  end

  
end