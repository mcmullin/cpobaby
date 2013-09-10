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

require 'spec_helper'

describe Product do

  before { @product = FactoryGirl.build(:product) }

  subject { @product }

  it { should respond_to(:item_number) }
  it { should respond_to(:description) }
  it { should respond_to(:category) }
  it { should respond_to(:current_retail_price) }
  it { should respond_to(:current_cpo) }
  it { should respond_to(:current_point_value) }
  it { should respond_to(:discontinued) }
  it { should respond_to(:state) }
  it { should respond_to(:line_items) }

  it { should be_valid }
  it { should_not be_discontinued }

  it { should_not allow_mass_assignment_of(:state) }

  it { should have_many(:line_items) }

  describe 'state:' do
    describe ':incomplete' do
      it 'initially' do
        should be_incomplete
      end

      it { should validate_uniqueness_of(:item_number) }
      describe 'when item number' do
        describe 'is invalid' do
          it 'should be invalid' do
            item_numbers = %w[100F 200H-1Z 1 10000 1000r]
            item_numbers.each do |invalid_item_number|
              @product.item_number = invalid_item_number
              @product.should_not be_valid
            end
          end
        end

        describe 'is valid' do
          it 'should be valid' do
            item_numbers = %w[1000WRB 81 777-1 100H-2 5000DBDD-2]
            item_numbers.each do |valid_item_number|
              @product.item_number = valid_item_number
              @product.should be_valid
            end
          end
        end
      end
    end

    describe ':submitted' do
      before { @product.submit }
      it 'after :submit' do
        should be_submitted
      end

      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:category) }

      describe 'when not discontinued' do
        it { should validate_numericality_of(:current_retail_price) }
        it { should validate_numericality_of(:current_cpo) }
        it { should validate_numericality_of(:current_point_value) }
      end

      describe 'when discontinued' do
        before { @product.discontinued = true }

        describe 'when current_retail_price, _cpo, and _point_value' do
          describe 'are present' do
            it { should_not be_valid }
          end

          describe 'are not present' do
            before do
              @product.current_retail_price = ' '
              @product.current_cpo = ' '
              @product.current_point_value = ' '
            end
            it { should be_valid }
          end
        end
      end

      describe 'but then after :confirm' do
        before { @product.confirm }
        it { should_not be_submitted }
        it { should be_confirmed }
      end
    end

    describe ':confirmed' do
      before do
        @product.submit
        @product.confirm
      end
      it 'after :confirm' do
        should be_confirmed
      end

      describe 'but then after :submit' do
        before { @product.submit }
        it { should_not be_confirmed }
        it { should be_submitted }
      end
    end
  end

  # test before_destroy callback -- only reason product has_many :line_items
  # describe 'line_item associations' do
  #   # destroying product should fail if it has line items
  #   # and not fail if it doesn't
  # end
end
