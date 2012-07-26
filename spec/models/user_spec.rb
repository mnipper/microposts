require 'spec_helper'

describe User do

  before { @user = User.new(:name => "Example", :email => "user@example.com",
                    :password => "foobar", :password_confirmation => "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should be_valid }

  it "should not allow a user to be created without a name" do
    @user.name = ""
    @user.should_not be_valid
  end

  it "should not allow a user to be created without an email" do
    @user.email = ""
    @user.should_not be_valid
  end

  it "should not allow a user to be created if the name is too long" do
    @user.name = 'a' * 51
    @user.should_not be_valid
  end

  it "should not allow an invalid email" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |a|
      @user.email = a
      @user.should_not be_valid
    end
  end

  it "should allow a valid email" do
    addresses = %w[user@foo.COM A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each do |a|
      @user.email = a
      @user.should be_valid
    end
  end

  describe "when an email address is already taken" do
    before do
      user_with_dup_email = @user.dup
      user_with_dup_email.email = @user.email.upcase
      user_with_dup_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do

    before { @user.password = @user.password_confirmation = " " }

    it { should_not be_valid }
  end


  describe "when password doesn't match confirmation" do
    before { @user.password = "barfoo" }

    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }

    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let (:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end
