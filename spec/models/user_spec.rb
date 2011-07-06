require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge :name => "")
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name_user = User.new(@attr.merge :name => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    long_name_user.should_not be_valid
  end
  
  it "should accept names that are equal to 50 chars" do
    long_name_user = User.new(@attr.merge :name => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    long_name_user.should be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge :email => "")
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addreses" do
    addresses = %W[user@foo.com THE_USER@foo.bar.org first.last@foo.mx pozole2000@gmail.com pozole+mm@gmail.com]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge :email => address)
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addreses" do
    addresses = %W[user@foo,com THE_USER_at_foo.com first.last@foo]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge :email => address)
      invalid_email_user.should_not be_valid
    end
  end
  
  it 'should reject duplicate email addresses up to case' do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  # Tests that have to do with password validation!
  
  describe 'password validations' do
    it 'should require a password' do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).
      should_not be_valid
    end
    
    it 'should require a matching password confirmation' do
      User.new(@attr.merge(:password_confirmation => 'invalid')).
      should_not be_valid
    end
    
    it 'should reject short passwords' do
      short = 'a' * 5
      User.new(@attr.merge(:password => short, :password_confirmation => short)).
      should_not be_valid
    end
      
    it 'should reject long passwords' do
      long = 'a' * 41
      User.new(@attr.merge(:password => long, :password_confirmation => long)).
      should_not be_valid
    end
  end
  
  describe 'encrypted password' do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it 'should set the encrypted password' do
      @user.encrypted_password.should_not be_blank
    end
    
    describe 'has_password? method' do
      it 'should be true if the passwords match' do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it 'should be false if passwords dont match' do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe 'user authentication' do
      it 'should return the user for authenticaded users' do
        good_user = User.authenticate(@attr[:email], @attr[:password]).should_not be_nil
      end
      
      it 'should return nil for unknown email address' do
        wrong_email_user = User.authenticate('false@example.com', @attr[:password]).should be_nil
      end
      
      it 'should return nil for wrong password' do
        wrong_password_user = User.authenticate(@attr[:email], 'invalid').should be_nil
      end
    end
  end
end
