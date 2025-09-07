# db/seeds.rb
require 'faker'
Faker::Config.locale = 'ja'

puts "\n== Seeding start =="

# --------------- メール送信などの副作用を止める（例：after_createでメール送信する場合）
orig_perform_deliveries = ActionMailer::Base.perform_deliveries
ActionMailer::Base.perform_deliveries = false rescue nil

ActiveRecord::Base.transaction do
  # 既存データを綺麗にしたい場合はコメントアウト外して使用
  # Like.delete_all  if defined?(Like)
  # Comment.delete_all
  # Post.delete_all
  # User.delete_all

  # === Users 20 ===
  users = []
  20.times do |i|
    users << User.create!(
      name:  Faker::Name.name,
      email: format("user%03d@example.com", i + 1),
      password: "password" # Devise想定。BCrypt等のバリデーションがあっても通る値
    )
  end
  puts "Users: #{User.count}"

  # === Posts 20 ===
  posts = []
  20.times do
    author = users.sample
    posts << Post.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      body:  Faker::Lorem.paragraph(sentence_count: 3), # ← あなたのカラムが content なら body→content に
      user:  author
    )
  end
  puts "Posts: #{Post.count}"

  # === Comments 20 ===
  20.times do
    commenter = users.sample
    post      = posts.sample
    Comment.create!(
      body: Faker::Lorem.sentence(word_count: 8), # ← あなたのカラムが content なら body→content に
      user: commenter,
      post: post
    )
  end
  puts "Comments: #{Comment.count}"

  # もし Like も入れたい場合（任意）
  # (0...40).each do
  #   Like.create!(user: users.sample, post: posts.sample)
  # end
  # puts "Likes: #{Like.count}"
end

# 元に戻す
ActionMailer::Base.perform_deliveries = orig_perform_deliveries rescue nil

puts "== Seeding finished =="
