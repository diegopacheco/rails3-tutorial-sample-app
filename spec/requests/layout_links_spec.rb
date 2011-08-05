require 'spec_helper'

describe "LayoutLinks" do
  
  describe "when not signed in" do
    
      it "should have asignin link" do
          visit root_path
          response.should have_selector("a",:href    => signin_path,
                                            :content => "Signin")
      end
  end

  describe "when signed in" do
      before(:each) do
          @user = Factory(:user)
          visit signin_path
          fill_in :email,    :with => @user.email
          fill_in :password, :with => @user.password
          click_button
      end
      
      it "should havea signout link" do
          visit root_path
          response.should have_selector("a",:href=>signout_path,
                                            :content=>"Signout")
      end
      
      it "should havea profile link" do
          visit root_path
          response.should have_selector("a", :href => user_path(@user), :content => "Profile" )
      end   
  end

  it "should have a Home page at '/'" do
    get '/'  
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have a Help page at '/'" do
    get '/help'  
    response.should have_selector('title', :content => "Help")
  end      

  it "should have a sign up page at '/signup'" do
    get 'signup'
    response.should have_selector("title", :content => "Sign up") 
  end  

  it "should have the right links on the layout" do
    visit root_path
    
    click_link "About"
    response.should have_selector("title", :content => "About")     

    click_link "Help"
    response.should have_selector("title", :content => "Help")    

    click_link "Contact"
    response.should have_selector("title", :content => "Contact")

    click_link "Home"
    response.should have_selector("title", :content => "Home")

    click_link "Sign up now!"
    response.should have_selector("title", :content => "Sign up")

  end

end
