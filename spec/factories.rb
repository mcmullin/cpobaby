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
    number_confirmation { "#{number}" }
    email { Faker::Internet.safe_email }
    password 'password'
    password_confirmation 'password'
  end

  factory :address, aliases: [:billing_address, :shipping_address] do
    street { Faker::Address.street_address }
    secondary ''
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
  end

  factory :product do
    sequence(:item_number) { |n| (100 + n).to_s + 'GG' }
    sequence(:description) { |n| "Fake Product ##{n}" }
    category 'Fake Products'
    retail { rand(50) * 55 }
    cpo { retail * 50 / 55 }
    points { retail * 35 / 55 }

    factory :discontinued_product do
      discontinued true
      retail ''
      cpo ''
      points ''
    end
  end

  factory :order do
    number { (77770000 + rand(9999)).to_s }
    number_confirmation { "#{number}" }
    date { rand(730).days.ago }

    rep
    billing_address
    shipping_address { billing_address }

    factory :order_with_items do
      ignore do
        items_count 1
      end

      after(:create) do |order, evaluator|
        FactoryGirl.create_list(:line_item, evaluator.items_count, order: order)
      end
    end
  end

  factory :line_item do
    product
    order

    quantity { rand(12) }
  end
end
