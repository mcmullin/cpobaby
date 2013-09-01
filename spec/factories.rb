FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "admin_#{n}@example.com" }   
    password 'password'
    password_confirmation 'password'
  end

  factory :rep do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    number { (66660000 + rand(9999)).to_s }
    email { "#{first_name}.#{last_name}@example.com".downcase }
    password 'password'
    password_confirmation 'password'
  end

  factory :address, aliases: [:billing_address, :shipping_address] do
    line1 { Faker::Address.street_address }
    line2 ''
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }

    #addressable factory: :order
  end

  factory :product do
    sequence(:item_number) { |n| (100 + n).to_s + 'GG' }
    sequence(:description) { |n| "Fake Product ##{n}" }
    category 'Fake Products'
    current_retail_price { rand(50) * 55 }
    current_cpo { current_retail_price * 50 / 55 }
    current_point_value { current_retail_price * 35 / 55 }

    factory :discontinued_product do
      discontinued true
      current_retail_price ''
      current_cpo ''
      current_point_value ''
    end
  end

  factory :order do
    rep

    number { (77770000 + rand(9999)).to_s }
    number_confirmation { "#{number}" }
    date { rand(730).days.ago }

    # after_build do |order|
    #   order.billing_address = FactoryGirl.create(:address, addressable: order)
    #   order.shipping_address { order.billing_address }
    # end
    billing_address
    shipping_address { billing_address }

    factory :order_with_items do # does not work yet - NoMethodError: undefined method `total_items' for nil:NilClass
      ignore do
        total_items 1
      end

      after_create do |order, evaluator|
        FactoryGirl.create_list(:line_item, evaluator.total_items, order: order)
      end
    end
  end

  factory :line_item do
    product
    quantity 1
  end

end
