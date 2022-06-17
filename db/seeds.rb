# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

(1..10).to_a.each do |i|
  u = User.create(name: "test#{i}", email: "test#{i}@test.com", password: 'password')
  u.save
end

puts 'Created 10 users'

u1 = User.first
u2 = User.find(2)

u1.sent_requests.create(friend: u2)
u2.sent_requests.create(friend: User.last).save

puts 'Two requests created (u1 <-> u2, u2 <-> u10'

r = Request.first
r.accepted = true
r.save

puts 'Accepted between user1 and user2 only'

post = u1.posts.build(content: 'Content of the post')
post.save

puts 'Created post that belongs to user1'

comment = post.comments.build(content: 'Comment on post 0', user_id: 1)
comment.save

puts 'Created a comment on post.'
