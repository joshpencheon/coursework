require File.dirname(__FILE__) + '/../spec_helper'

describe FaceboxHelper do 
  before(:each) do
    ActionController::Routing::Routes.draw do |map|
      map.resources :users
      map.connect ':controller/:action/:id'
    end
  end
  
  context 'when calling with text' do
    context 'without a css class' do
      it "should add behaviour to onclick attribute" do
        helper.link_to_facebox('click for message', :text => 'hello, world!').should ==
          %q(<a href="javascript:void(0);" onclick="jQuery.facebox('hello, world!')">click for message</a>)
      end
    end
    
    context 'with a css class' do
      it "should add css class to css attribute" do
        helper.link_to_facebox('click for message', :text => 'hello, world!', :class => 'simple').should ==
          %q(<a href="javascript:void(0);" onclick="jQuery.facebox('hello, world!', 'simple')">click for message</a>)        
      end
      
      context 'and with a misc. attribute' do
        it "should add both css class and misc attribute to tag" do
          helper.link_to_facebox('click for message', :text => 'hello, world!', :class => 'simple', :id => 'my_link').should ==
            %q(<a href="javascript:void(0);" id="my_link" onclick="jQuery.facebox('hello, world!', 'simple')">click for message</a>)          
        end
      end
    end
  end
  
  context 'when calling with an image and misc. attribute' do
    it "should prepend file location to image path and add misc. attribute to tag" do
      helper.link_to_facebox('click for image', :image => 'rails.png', :id => 'logo').should ==  
        %q(<a href="/images/rails.png" id="logo" rel="facebox">click for image</a>)
    end
  end

  context 'when calling to be filled with a div' do
    context 'and a css has not been specified' do
      it "should add rel='facebox' tag and prepend div id with a hash" do
        helper.link_to_facebox('click for T&Cs', :div => 'terms_and_conditions').should ==
          %q(<a href="#terms_and_conditions" rel="facebox">click for T&Cs</a>)        
      end
    end
    
    context 'and a css has been specified' do
      it "should add rel='facebox.className' tag and prepend div id with a hash" do
        helper.link_to_facebox('click for T&Cs', :div => 'terms_and_conditions', :class => 'boring-font').should ==
          %q(<a href="#terms_and_conditions" rel="facebox.boring-font">click for T&Cs</a>)        
      end
    end
  end

  context 'when calling to be filled with an AJAX response' do
    it "should add the converted path to the href attribute" do
      helper.link_to_facebox('click for more user info', :ajax => users_path).should ==  
        %q(<a href="/users" rel="facebox">click for more user info</a>)
    end
  end
end