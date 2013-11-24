# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name so long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
    end

  describe "when email so long" do
    before { @user.email = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      address = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_bar.com foo@bar+bar.com]
      address.each { |email|
        @user.email = email
        @user.should_not be_valid
      }
    end
  end

  describe "when email is valid" do
    it 'should be valid' do
      address  = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      address.each { |valid_address|
      @user.email = valid_address
      @user.should be_valid
      }
    end
  end



=begin
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
=end

 describe "when pass is not present" do
   before do
     @user.password = @user.password_confirmation =""
   end
   it { should_not be_valid }
 end

  describe "when pass not match" do
    before do
      @user.password_confirmation = "pass2"
    end
    it { should_not be_valid }
  end

  describe "when pass_confirm is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end


  # Test for User.authenticate
  describe "with password that`s too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  #ASKME почему при тестировании метода authenticate не тестируется случай, когда пустое мыло
  describe "return value of authenticate method" do
    before { @user.save() }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "when valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe " when invalid password" do
      let(:not_found_user) { found_user.authenticate('invalid') }

      it { should_not == not_found_user }
      specify { not_found_user.should be false }
    end
  end
  describe "when email not  be downcase in before_save" do
    let(:email) { "DENIS2@Examole.com" }
    before do
      @user.email = email
      @user.save()
    end

    let(:find_user) {User.find(name: @user.name) }
    it{find_user.email.should == email.downcase }
  end

end

