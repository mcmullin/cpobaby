require 'spec_helper'

describe 'Product pages' do

  subject { page }

  describe 'index' do

    let(:rep) { FactoryGirl.create(:rep) }

    before(:each) do
      sign_in_rep rep
      visit products_path
    end

    it { should have_selector('title', text: 'Products') }
    it { should have_selector('h2',    text: 'Products') }

    # for admins
    #   new product button
    #   export text & link
    #   import products / test with real .csv

    describe 'table' do

      before(:all) do
        3.times { FactoryGirl.create(:product) }
        FactoryGirl.create(:discontinued_product)
      end
      after(:all)  { Product.delete_all }

      it 'should list each product' do
        Product.all.each do |product|
          page.should have_selector('td', text: product.state.upcase)
          page.should have_selector('td', text: product.item_number)
          page.should have_selector('td', text: product.description)
          page.should have_selector('td', text: product.category)
          if product.discontinued
            page.should have_selector('td', text: 'PRODUCT DISCONTINUED')
          else
            page.should have_selector('td', text: number_to_currency(product.current_retail_price))
            page.should have_selector('td', text: number_with_precision(product.current_cpo, strip_insignificant_zeros: true))
            page.should have_selector('td', text: number_with_precision(product.current_point_value, strip_insignificant_zeros: true))
          end
        end
      end

      describe 'links' do

        it { should_not have_link('Show') }
        it { should_not have_link('Edit') }
        it { should_not have_link('Destroy') }

        describe 'as an admin' do
          let(:admin) { FactoryGirl.create(:admin) }
          before do
            sign_in_admin admin
            visit products_path
          end

          it { should have_link('Show', href: product_path(Product.first)) }
          it { should have_link('Edit', href: edit_product_path(Product.first)) }
          it { should have_link('Destroy', href: product_path(Product.first)) }

          it 'should be able to destroy a product' do
            expect { click_link('Destroy') }.to change(Product, :count).by(-1)
          end
        end
      end
    end
  end

  
end