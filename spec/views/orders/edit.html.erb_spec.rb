require 'spec_helper'

describe "orders/edit" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :number => "MyString",
      :rep_id => 1
    ))
  end

  it "renders the edit order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", order_path(@order), "post" do
      assert_select "input#order_number[name=?]", "order[number]"
      assert_select "input#order_rep_id[name=?]", "order[rep_id]"
    end
  end
end
