# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  number     :string(255)
#  date       :date
#  rep_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ActiveRecord::Base
  attr_accessor :rep_number
  attr_accessible :number, :number_confirmation, :date, :rep_number,
                  :billing_address_attributes, :shipping_address_attributes, :line_items_attributes

  belongs_to :rep

  has_one :billing_address, class_name: 'Address', as: :addressable
  has_one :shipping_address, class_name: 'Address', as: :addressable
  accepts_nested_attributes_for :billing_address, :shipping_address

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  accepts_nested_attributes_for :line_items, reject_if: lambda { |a| a[:product_id].blank? }, allow_destroy: true

  validates :number, confirmation: true, uniqueness: true, format: { with: /\A\d{8}\z/ }
  validates :number_confirmation, presence: true
  validates :date, presence: true
  validates :rep_id, presence: true
  validates :billing_address, presence: true
  validates :shipping_address, presence: true
end
