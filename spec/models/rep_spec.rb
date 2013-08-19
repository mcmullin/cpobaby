# == Schema Information
#
# Table name: reps
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  number                 :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe Rep do

  before { @rep = Rep.new(first_name: "Example", last_name: "Rep", number: "99999999", 
                          email: "rep@example.com", password: "password", password_confirmation: "password") }

  subject { @rep }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:number) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:orders) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to encrypted_password attribute" do
      expect do
        Rep.new(encrypted_password: "")
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when first name is not present" do
    before { @rep.first_name = " " }
    it { should_not be_valid }
  end

  describe "when last name is not present" do
    before { @rep.last_name = " " }
    it { should_not be_valid }
  end

  # number presence, length, numericality

  describe "when email is not present" do
    before { @rep.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @rep.email = invalid_address
        @rep.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @rep.email = valid_address
        @rep.should be_valid
      end      
    end
  end

  describe "when email address is already taken" do
    before do
      rep_with_same_email = @rep.dup
      rep_with_same_email.email = @rep.email.upcase
      rep_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @rep.email = mixed_case_email
      @rep.save
      @rep.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before { @rep.password = @rep.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @rep.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # describe "when password confirmation is nil" do
  #   before { @rep.password_confirmation = nil }
  #   it { should_not be_valid }
  # end

  describe "with a password that's too short" do
    before { @rep.password = @rep.password_confirmation = "a" * 7 }
    it { should be_invalid }
  end

  # describe "return value of authenticate method" do
  #   before { @user.save }
  #   let(:found_user) { User.find_by_email(@user.email) }

  #   describe "with valid password" do
  #     it { should == found_user.authenticate(@user.password) }
  #   end

  #   describe "with invalid password" do
  #     let(:user_for_invalid_password) { found_user.authenticate("invalid") }

  #     it { should_not == user_for_invalid_password }
  #     specify { user_for_invalid_password.should be_false }
  #   end
  end
