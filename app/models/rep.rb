class Rep < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable #, :confirmable

  attr_accessible :first_name, :last_name, :number, :email, :password, :password_confirmation, :remember_me

  def full_name
    first_name + " " + last_name
  end
end
