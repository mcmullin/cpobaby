namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_reps
    # make_microposts
    # make_relationships
  end
end

def make_reps
  admin = Rep.create!(first_name: "Robert", last_name: "McMullin", number: "33089392", 
                      email: "rob@cpobaby.com", password: "password", password_confirmation: "password")
  admin.toggle!(:admin)
  5.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    number = "9999000#{n+1}"
    email = "example-#{n+1}@cpobaby.com"
    password  = "password"
    rep = Rep.create!(first_name: first_name, last_name: last_name, number: number, 
                      email: email, password: password, password_confirmation: password)
    #rep.toggle!(:activated)
  end
end

=begin

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

=end