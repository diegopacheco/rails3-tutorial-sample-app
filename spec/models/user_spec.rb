require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { 
                :name => "Example User", 
                :email => "user@example.com",                 
                :password => "foobar",
                :password_confirmation => "foobar"                
             }
  end     

  it "1. should create a new instance given valid attributes" do
    User.create!(@attr)  
  end  

  it "2. should require a name" do
     no_name_user = User.new(@attr.merge(:name => ""))
     no_name_user.should_not be_valid 
  end

  it "3. should reject names that are too long" do
     long_name = "a" * 51
     long_name_user = User.new(@attr.merge(:name => long_name))
     long_name_user.should_not be_valid   
  end

  it "4. should accept valid email addresses" do
     addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
     addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid     
     end     
  end 

  it "5. should reject invalid email addresses" do
     addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
     addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should_not be_valid     
     end     
  end 

  it "6. should reject duplicate email addresses" do
     User.create!(@attr)
     user_with_duplicate_email = User.new(@attr) 
     user_with_duplicate_email.should_not be_valid
  end  

  it "7. should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid     
  end

  it "8. should require a email" do
     no_name_user = User.new(@attr.merge(:email => ""))
     no_name_user.should_not be_valid 
  end

  describe "password validations" do
    
      it "9. should require a password" do
         User.new(@attr.merge(:password => "", :password_confirmation => "")).
                 should_not be_valid         
      end  
    
      it "10. should reject short passwords" do
         short = "a" * 5
         hash  = @attr.merge(:password => short, :password_confirmation => short)  
         User.new(hash).should_not be_valid     
      end

      it "11. should reject long passwords" do
         long  = "a" * 41
         hash  = @attr.merge(:password => long, :password_confirmation => long)  
         User.new(hash).should_not be_valid     
      end

      it "12. should require a matching password confirmation" do
         User.new(@attr.merge(:password_confirmation => 'invalid')).
                 should_not be_valid           
      end

  end

  describe "password encryption" do

      before(:each) do   
         @user = User.create!(@attr)
      end  

      it "13. should have a encrypted password attribute" do
         @user.should respond_to(:encrypted_password)  
      end

      it "14. should set the encrypted password" do
         @user.encrypted_password.should_not be_blank
      end

      describe "has_password? method" do
            
            it "15. should be true if passwords match" do         
               @user.has_password?(@attr[:password]).should be_true
            end  

            it "16. should be false if the passwords don't match" do
               @user.has_password?("invalid").should be_false  
            end 

      end

  end
 
end


# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

