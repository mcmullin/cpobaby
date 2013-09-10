# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  street           :string(255)
#  secondary        :string(255)
#  city             :string(255)
#  state            :string(255)
#  zip              :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Address < ActiveRecord::Base
  attr_accessible :street, :secondary, :city, :state, :zip

  belongs_to :addressable, polymorphic: true

  validates :street, presence: true
end
