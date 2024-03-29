# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  product_id :integer
#  order_id   :integer
#  quantity   :integer
#  free       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :decimal(, )
#  subtotal   :decimal(, )
#

class LineItem < ActiveRecord::Base
  attr_accessible :quantity, :free, :price, :subtotal, :product_id, :order_id

  belongs_to :product
  belongs_to :order

  validates :quantity, :price, :subtotal, numericality: true
  validates :product_id, presence: true
  validates :order_id,   presence: true, unless: :new_record?
end
