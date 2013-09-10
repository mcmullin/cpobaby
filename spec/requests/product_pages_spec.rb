require 'spec_helper'

describe 'Product pages' do

  subject { page }

  shared_examples_for 'all product pages' do
    it { should have_selector('title', text: full_title(page_title_and_heading)) }
    it { should have_selector('h2',    text: page_title_and_heading) }
  end

  let(:rep) { FactoryGirl.create(:rep) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe '#index' do
    before(:each) do
      sign_in_rep rep
      visit products_path
    end

    let(:page_title_and_heading) { 'Products' }
    it_should_behave_like 'all product pages'

    describe 'admin controls' do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in_admin admin
        visit products_path
      end

      it { should have_link('New Product', href: new_product_path) }

      it { should have_link('.csv', href: products_path + '.csv') }
      # test product import form submission with real .csv file
    end

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
            page.should have_selector('td', text: number_to_currency(product.retail))
            page.should have_selector('td', text: number_with_precision(product.cpo, strip_insignificant_zeros: true))
            page.should have_selector('td', text: number_with_precision(product.points, strip_insignificant_zeros: true))
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

          it 'should be able to #destroy a product' do
            expect { click_link('Destroy') }.to change(Product, :count).by(-1)
          end

          # it 'should be able to confirm a product'
        end
      end
    end
  end

  describe '#show' do
    let(:product) { FactoryGirl.create(:product) }
    before(:each) do
      sign_in_admin admin
      visit product_path(product.id)
    end

    let(:page_title_and_heading) { "Product ##{product.item_number}" }
    it_should_behave_like 'all product pages'

    it { should have_link('Edit', href: edit_product_path(product.id)) }

    describe 'table links' do
      it { should_not have_link('Show') }
      it { should have_link('Edit', href: edit_product_path(Product.first)) }
      it { should have_link('Destroy', href: product_path(Product.first)) }
    end
  end

  describe '#new' do
    before(:each) do
      sign_in_admin admin
      visit new_product_path
    end

    let(:page_title_and_heading) { 'New Product' }
    it_should_behave_like 'all product pages'

    describe '#create' do
      let(:submit) { 'Create Product' }

      describe 'with invalid information' do
        it 'should not create a product' do
          expect { click_button submit }.not_to change(Product, :count)
        end

        describe 'after submission' do
          before { click_button submit }

          it { should have_selector('title', text: full_title('New Product')) }
          it { should have_selector('div.alert.alert-danger') }
        end
      end

      describe 'with valid information' do
        let(:item_number)  { '11GG' }
        before { fill_in 'Item number', with: item_number }

        it 'should create a product' do
          expect { click_button submit }.to change(Product, :count).by(1)
        end

        describe 'after submission' do
          before { click_button submit }
          let(:product) { Product.find_by_item_number(item_number) }

          it { should have_selector('title', text: full_title("Editing Product ##{product.item_number}")) }
          it { should have_selector('div.alert.alert-warning') }

          specify { product.reload.state.should == 'incomplete' }
        end
      end
    end

    it { should have_link('back to Products', href: products_path) }
  end

  describe '#edit' do
    let(:product) { FactoryGirl.create(:product) }
    before(:each) do
      sign_in_admin admin
      visit edit_product_path(product.id)
    end

    let(:page_title_and_heading) { "Editing Product ##{product.item_number}" }
    it_should_behave_like 'all product pages'

    describe '#update' do
      let(:submit) { 'Update Product' }

      describe 'with invalid information after submission' do
        before do
          fill_in 'Description', with: ''
          click_button submit
        end

        it { should have_selector('title', text: full_title("Editing Product ##{product.item_number}")) }
        it { should have_selector('div.alert.alert-danger') }
      end

      describe 'with valid information after submission' do
        let(:new_description)  { 'New Description' }
        before do
          fill_in 'Description', with: new_description
          click_button submit
        end

        it { should have_selector('title', text: full_title('Products')) }
        it { should have_selector('div.alert.alert-success') }

        specify { product.reload.description.should  == new_description}
        specify { product.reload.state.should == 'submitted' }
      end
    end

    it { should have_link("back to Product ##{product.item_number}", href: product_path(product.id)) }
    it { should have_link('back to Products', href: products_path) }
  end
end
