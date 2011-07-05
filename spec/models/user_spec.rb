require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
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
end
