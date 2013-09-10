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
  attr_accessible :number, :number_confirmation, :date, :rep_number,
                  :billing_address_attributes, :shipping_address_attributes,
                  :billing_phone_attributes, :shipping_phone_attributes, :line_items_attributes

  belongs_to :rep

  has_one :billing_address, class_name: 'Address', as: :addressable
  has_one :shipping_address, class_name: 'Address', as: :addressable
  accepts_nested_attributes_for :billing_address, :shipping_address

  has_one :billing_phone, class_name: 'Phone', as: :phoneable
  has_one :shipping_phone, class_name: 'Phone', as: :phoneable
  accepts_nested_attributes_for :billing_phone, :shipping_phone

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  accepts_nested_attributes_for :line_items, reject_if: lambda { |a| a[:product_id].blank? }, allow_destroy: true

  validates :number, uniqueness: true, format: { with: /\A\d{8}\z/ }, confirmation: true, if: :new_record?
  validates :number_confirmation, presence: true, if: :new_record?
  validates :date, date: { after: Proc.new { Date.new(1949) }, message: 'is invalid' }
  validates :rep_number, format: { with: /\A\d{8}\z/ }
  validates :billing_address, :shipping_address, :billing_phone, :shipping_phone, presence: true

  def rep_number
    rep.try(:number)
  end
  
  def rep_number=(number)
    self.rep = Rep.find_by_number(number) if number.present?
  end
end
