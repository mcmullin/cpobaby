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
  belongs_to :rep

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  accepts_nested_attributes_for :line_items, reject_if: lambda { |a| a[:product_id].blank? }, allow_destroy: true

  attr_accessible :number, :date, :rep_id, :line_items_attributes

  validates :number, presence: true, uniqueness: true, format: { with: /\A\d{8}\z/ }
  #validates :date, presence: true
  validates :rep_id, presence: true
end
