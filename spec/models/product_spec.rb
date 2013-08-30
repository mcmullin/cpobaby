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
#

require 'spec_helper'

describe Product do

  before { @product = Product.new(item_number: "1000R", description: "fake knife", category: "none",
                                  current_retail_price: "100", current_cpo: "90", current_point_value: "75", ) }

  subject { @product }

  it { should respond_to(:item_number) }
  it { should respond_to(:description) }
  it { should respond_to(:category) }
  it { should respond_to(:current_retail_price) }
  it { should respond_to(:current_cpo) }
  it { should respond_to(:current_point_value) }

  it { should be_valid }

  describe "when item number is not present" do
    before { @product.item_number = " " }
    it { should_not be_valid }
  end

  describe "when item number is nil" do
    before { @product.item_number = nil }
    it { should_not be_valid }
  end

  describe "when item number is invalid" do
    it "should be invalid" do
      item_numbers = %w[100G 200H-1Z 1 10000 1000r]
      item_numbers.each do |invalid_item_number|
        @product.item_number = invalid_item_number
        @product.should_not be_valid
      end      
    end
  end

  describe "when item number is valid" do
    it "should be valid" do
      item_numbers = %w[1000WRB 81 777-1 100H-2 5000DBDD-2]
      item_numbers.each do |valid_item_number|
        @product.item_number = valid_item_number
        @product.should be_valid
      end      
    end
  end

  describe "when item number is already taken" do
    before do
      product_with_same_item = @product.dup
      product_with_same_item.item_number = @product.item_number.upcase
      product_with_same_item.save
    end

    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @product.description = " " }
    it { should_not be_valid }
  end

  describe "when description is nil" do
    before { @product.description = nil }
    it { should_not be_valid }
  end

  describe "when category is not present" do
    before { @product.category = " " }
    it { should_not be_valid }
  end

  describe "when category is nil" do
    before { @product.category = nil }
    it { should_not be_valid }
  end

  # current values' presence, numericality

end
