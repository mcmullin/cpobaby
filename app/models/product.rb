# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  item_number          :string(255)
#  description          :string(255)
#  category             :string(255)
#  current_retail_price :decimal(, )
#  current_cpo          :decimal(, )
#  current_point_value  :decimal(, )
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  discontinued         :boolean          default(FALSE)
#  state                :string(255)
#

class Product < ActiveRecord::Base
  attr_accessible :item_number, :description, :category, :current_retail_price, :current_cpo, :current_point_value, :discontinued

  has_many :line_items

  validates :item_number, uniqueness: true, format: { with: /\A\d{2,4}[-12RCWPHTSDBKG]{0,6}\z/ }

  before_destroy :ensure_not_referenced_by_any_line_item

  state_machine :state, initial: :incomplete do
    # after_transition any => :submitted, do: [:notify_moderators]

    event :submit do # i.e. for moderator review
      transition any => :submitted # or 'pending (confirmation)'
    end

    event :confirm do
      transition :submitted => :confirmed
    end

    state :submitted do
      validates :description,          presence: true
      validates :category,             presence: true
      validates :current_retail_price, numericality: true, unless: :discontinued
      validates :current_cpo,          numericality: true, unless: :discontinued
      validates :current_point_value,  numericality: true, unless: :discontinued
      validates :current_retail_price, absence: true, if: :discontinued
      validates :current_cpo,          absence: true, if: :discontinued
      validates :current_point_value,  absence: true, if: :discontinued
    end

    state :confirmed
  end

  def position
    newnum = item_number.sub(/[-]/, '~')
    nnti ||= newnum.to_i
    if nnti < 100
      newnum = newnum.prepend('00')
    elsif nnti < 1000
      newnum = newnum.prepend('0')
    end
    @position ||= newnum
  end

  def item_and_description
    item_number + ": " + description
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      product = find_by_id(row["id"]) || new # breaks import on first existing product?!!!
      product.attributes = row.to_hash.slice(*accessible_attributes)
      product.save!
    end
  end

  private

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end
end 
