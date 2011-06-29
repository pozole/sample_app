require 'spec_helper'

describe "LayoutLinks" do
    
    it "should have a Home page on /" do
      get '/'
      response.should have_selector('title', :content => 'Home')
    end
    
    it "should have a Contact page on /contact" do
      get '/contact'
      response.should have_selector('title', :content => 'Contact')
    end
    
        it "should have a About page on /about" do
      get '/about'
      response.should have_selector('title', :content => 'About')
    end
    
        it "should have a Home page on /help" do
      get '/help'
      response.should have_selector('title', :content => 'Help')
    end
    
    it "should have a Sign Up page on /signup" do
      get '/signup'
      response.should have_selector('title', :content => 'Sign Up')
    end

end
