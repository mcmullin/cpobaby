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

class Rep < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :number, :number_confirmation, :email, :password, :password_confirmation, :remember_me

  has_many :orders

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :number, presence: true, confirmation: true, uniqueness: true, format: { with: /\A\d{8}\z/ }
  validates :number_confirmation, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 8 } # 'presence: true' is somehow unneccesary here
  validates :password_confirmation, presence: true # this line appears to do nothing

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  def full_name
    first_name + " " + last_name
  end

  def number_and_full_name
    number + " (" + self.full_name + ")"
  end
end
