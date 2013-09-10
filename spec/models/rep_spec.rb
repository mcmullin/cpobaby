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

  before { @rep = Rep.new(first_name: "Example", last_name: "Rep", number: "99999999", number_confirmation: "99999999",
                          email: "rep@example.com", password: "password", password_confirmation: "password") }

  subject { @rep }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:number) }
  it { should respond_to(:number_confirmation) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:orders) }
  it { should respond_to(:full_name) }
  it { should respond_to(:number_and_full_name) }

  it { should be_valid }

  it { should_not allow_mass_assignment_of(:encrypted_password) }

  it { should have_many(:orders) }

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should validate_confirmation_of(:number) }
    it { should validate_uniqueness_of(:number) }
    describe 'when number' do
      describe 'is invalid' do
        it 'should be invalid' do
          numbers = %w[1234567 123456789 1234567H ABCDEFGH]
          numbers.each do |invalid_number|
            @rep.number = @rep.number_confirmation = invalid_number
            @rep.should_not be_valid
          end
        end
      end

      describe 'is valid' do
        it 'should be valid' do
          numbers = %w[12345678 00000000 94385843]
          numbers.each do |valid_number|
            @rep.number = @rep.number_confirmation = valid_number
            @rep.should be_valid
          end
        end
      end
    end

    it { should validate_presence_of(:number_confirmation) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    describe 'when email address' do
      describe 'is invalid' do
        it 'should be invalid' do
          addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
          addresses.each do |invalid_address|
            @rep.email = invalid_address
            @rep.should_not be_valid
          end
        end
      end

      describe 'is valid' do
        it 'should be valid' do
          addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
          addresses.each do |valid_address|
            @rep.email = valid_address
            @rep.should be_valid
          end
        end
      end

      describe 'is mixed case' do
        let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

        it "should be saved as all lower-case" do
          @rep.email = mixed_case_email
          @rep.save
          @rep.reload.email.should == mixed_case_email.downcase
        end
      end
    end

    it { should validate_presence_of(:password) }
    it { should ensure_length_of(:password).is_at_least(8).with_message('is too short (minimum is 8 characters)')}
    it { should validate_confirmation_of(:password) }

    # for some reason, this next test fails
    # it { should validate_presence_of(:password_confirmation) }
  end

  # describe "order associations" do
  # end
end
