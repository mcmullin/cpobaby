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
#

class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  
  attr_accessible :quantity, :free, :product_id, :order_id
end
