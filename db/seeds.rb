
User.create!(name:  "a",
  email: "a@a.a",
  password: "aaaaaa",
  password_confirmation: "aaaaaa",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

users=[]
99.times do |i|
  name  = "User #{i+1}"
  email = "user-#{i+1}@mail.com"
  password = "password"
  user=User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now
              )
  users << user
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end







