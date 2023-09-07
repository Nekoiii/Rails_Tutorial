
User.create!(name:  "a",
  email: "a@a.a",
  password: "aaaaaa",
  password_confirmation: "aaaaaa")

users=[]
20.times do |i|
  name  = "User #{i+1}"
  email = "user-#{i+1}@mail.com"
  password = "password"
  user=User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
              #  activated: true,
              #  activated_at: Time.zone.now
              )
  users << user
end