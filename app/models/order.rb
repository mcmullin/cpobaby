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
  attr_accessible :number, :number_confirmation, :date, :rep_number, :email, :ship_to_billing,
                  :billing_first_name, :billing_last_name, :shipping_first_name, :shipping_last_name,
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
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, allow_blank: true
  validates :billing_first_name, :billing_last_name, :shipping_first_name, :shipping_last_name, presence: true
  validates :billing_address, :shipping_address, :billing_phone, :shipping_phone, presence: true
  validate  :shipping_equals_billing, if: :ship_to_billing # superfluous now, and especially once ship_to_b disables fields 

  before_validation :enforce_ship_to_billing

  def rep_number
    rep.try(:number) # getters don't require 'self.'
  end
  
  def rep_number=(number)
    self.rep = Rep.find_by_number(number) if number.present?
  end

  def billing_full_name
    billing_first_name + ' ' + billing_last_name
  end

  def shipping_full_name
    shipping_first_name + ' ' + shipping_last_name
  end

  def billing_phone_with_extension
    ActionController::Base.helpers.number_to_phone(billing_phone.number, extension: billing_phone.extension)
  end

  def shipping_phone_with_extension
    ActionController::Base.helpers.number_to_phone(shipping_phone.number, extension: shipping_phone.extension)
  end

  private

    def enforce_ship_to_billing
      if ship_to_billing
        self.shipping_first_name = billing_first_name
        self.shipping_last_name = billing_last_name
        self.shipping_address = billing_address
        self.shipping_phone = billing_phone
      end
    end

    def shipping_equals_billing
      @errors.add(:shipping_first_name, "doesn't match billing") unless shipping_first_name == billing_first_name
      @errors.add(:shipping_last_name, "doesn't match billing") unless shipping_last_name == billing_last_name
      add_shipping_address_errors(:street)
      add_shipping_address_errors(:secondary)
      add_shipping_address_errors(:city)
      add_shipping_address_errors(:state)
      add_shipping_address_errors(:zip)
      add_shipping_phone_errors(:number)
      add_shipping_phone_errors(:extension)
      add_shipping_phone_errors(:country)
      add_shipping_phone_errors(:description)
    end

    def add_shipping_address_errors(attribute)
      if shipping_address[attribute] != billing_address[attribute]
        shipping_address.errors.add(attribute, "doesn't match billing")
        @errors.add(:"shipping_address.#{attribute}", "doesn't match billing")
      end
    end

    def add_shipping_phone_errors(attribute)
      if shipping_phone[attribute] != billing_phone[attribute]
        shipping_phone.errors.add(attribute, "doesn't match billing")
        @errors.add(:"shipping_phone.#{attribute}", "doesn't match billing")
      end
    end
end
