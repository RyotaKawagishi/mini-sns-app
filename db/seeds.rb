# 開発用のデフォルトユーザーを作成する
User.find_or_create_by!(email: "example@example.com") do |user|
  user.name = "Example User"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true
  user.activated = true
  user.activated_at = Time.zone.now
end

# メインのサンプルユーザーを1人作成する
User.find_or_create_by!(email: "example1@railstutorial.org") do |user|
  user.name =  "Example User"
  user.password =             "password1"
  user.password_confirmation = "password1"
  user.admin = true
  user.activated = true
  user.activated_at = Time.zone.now
end

User.create!(name:  "ExampleUser2",
             email: "example2@railstutorial.org",
             password:              "password2",
             password_confirmation: "password2",
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "ExampleUser3",
             email: "example3@railstutorial.org",
             password:              "password3",
             password_confirmation: "password3",
             admin: false,
             activated: true,
             activated_at: Time.zone.now)
# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+4}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# メンション付きのマイクロポストを生成する
user2 = User.find_by(name: "ExampleUser2")
user3 = User.find_by(name: "ExampleUser3")
user2.microposts.create!(content: "Hi, #{user3.name}. How are you?", in_reply_to: user3.id)
user3.microposts.create!(content: "Hello, #{user2.name}. I'm fine. Thanks!", in_reply_to: user2.id)

# ユーザーフォローのリレーションシップを作成する
users = User.all
user  = users.first
following = users[4..50]
followers = users[5..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }