# == Schema Information
#
# Table name: phones
#
#  id             :integer          not null, primary key
#  number         :string(10)
#  extension      :string(5)
#  country_code   :string(4)
#  description    :string(255)
#  phoneable_id   :integer
#  phoneable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Phone < ActiveRecord::Base
  attr_accessible :number, :extension, :country, :description

  belongs_to :phoneable, polymorphic: true

  validates :number, :country, numericality: { only_integer: true }
  validates :extension, numericality: { only_integer: true }, allow_blank: true

  def number=(num)
    num.gsub!(/\D/, '') # if num.is_a?(String)
    super(num)
  end

  def country=(num)
    num.gsub!(/\D/, '')
    super(num)
  end

  def extension=(num)
    num.gsub!(/\D/, '')
    super(num)
  end
end
