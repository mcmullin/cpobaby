namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_admin
    make_reps
    make_products
    make_orders
  end
end

def make_admin
  admin = Admin.create!(email: "rob@cpobaby.com", password: "password", password_confirmation: "password")
end

def make_reps
  rob = Rep.create!(first_name: "Robert", last_name: "McMullin", number: "33089392", 
                    email: "robert.mcmullin@gmail.com", password: "password", password_confirmation: "password")
  4.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    number = "9999000#{n+1}"
    email = "example-#{n+1}@example.com"
    password  = "password"
    rep = Rep.create!(first_name: first_name, last_name: last_name, number: number, 
                      email: email, password: password, password_confirmation: password)
    #rep.toggle!(:activated)
  end
end

def make_products
  Product.import(File.open("#{Rails.root}/public/products.csv"))
end

def make_orders
end
