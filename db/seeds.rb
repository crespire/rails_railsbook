# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

3.times do |i|
  u = User.create(name: "test#{i}", email: "test#{i}@test.com", password: 'password')
  u.save
end

puts 'Created three users'

u1 = User.first
u2 = User.find(2)

u1.sent_requests.build(receiver: u2, accepted: true).save
u2.sent_requests.build(receiver: User.last).save

puts 'Created 2 requests, accepted between user1 and user2, pending between user2 and user3'

post = u1.posts.build(content: 'Content of the post')
post.save

puts 'Created post that belongs to user1'

comment = post.comments.build(content: 'Comment on post 0', user_id: 1)
comment.save

puts 'Created a comment on post.'