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
#

class Product < ActiveRecord::Base
  attr_accessible :item_number, :description, :category, :current_retail_price, :current_cpo, :current_point_value

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  VALID_ITEM_NUMBER_REGEX = /\A\d{2,4}[-12RCWPHTSDBK]{0,6}\z/
  validates :item_number, presence: true, format: { with: VALID_ITEM_NUMBER_REGEX }, uniqueness: true
  validates :description, presence: true
  validates :category, presence: true
  validates :current_retail_price, presence: true, numericality: true
  #validates :current_cpo, numericality: true
  #validates :current_point_value, numericality: true


  def position
    newnum = item_number.clone
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
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_id(row["id"]) || new
      product.attributes = row.to_hash.slice(*accessible_attributes)
      product.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
    #when '.ods' then Openoffice.new(file.path, nil, :ignore)
    #when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    #when '.xlsx' then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
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
