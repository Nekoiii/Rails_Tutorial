# frozen_string_literal: true

User.create!(name: 'a',
             email: 'a@a.a',
             password: 'aaaaaa',
             password_confirmation: 'aaaaaa',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

users = []
99.times do |i|
  name  = "User #{i + 1}"
  email = "user-#{i + 1}@mail.com"
  password = 'password'
  user = User.create!(name:,
                      email:,
                      password:,
                      password_confirmation: password,
                      activated: true,
                      activated_at: Time.zone.now)
  users << user
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content:) }
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
