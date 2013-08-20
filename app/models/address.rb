class Address < ActiveRecord::Base
  attr_accessible :line1, :line2, :city, :state, :zip

  belongs_to :addressable, polymorphic: true

  validates :line1, presence: true
end
