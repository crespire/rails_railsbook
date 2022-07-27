# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(name: 'test1', email: 'test1@test.com', password: 'password')

(2..5).to_a.each do |i|
  User.create(name: Faker::Name.name, email: "test#{i}@test.com", password: 'password')
end

puts 'Created 5 users'

until Request.count == 3
  user_a = User.all.sample
  user_b = User.all.sample
  next if user_a == user_b

  request = user_a.sent_requests.create(friend: user_b)
  request.notify
end

puts 'Created 3 requests'

2.times do
  request = Request.pending.sample
  request.accept_request
end

puts 'Accepted 2 requests'

test1 = User.first
User.all.each_with_index do |user, i|
  next if i.zero?
  next if test1.all_friends.include?(user)

  test1.sent_requests.create(friend: user, accepted: true)
end

puts 'All users friends with test1'

12.times do |i|
  User.all.sample.posts.create(content: "Content of #{i} post")
end

puts 'Created 12 posts belonging to random users'

6.times do
  comment = Post.all.sample.comments.create(content: 'Comment on post', user: User.all.sample)
  comment.notify
end

puts 'Created 6 comments on random posts, belonging to random users.'

3.times do
  like = Post.all.sample.likes.create(liked_by: User.all.sample.id)
  like.notify
end

puts 'Created 3 likes on posts.'

puts "Generated #{Notification.count} notifications (expect 12)."
