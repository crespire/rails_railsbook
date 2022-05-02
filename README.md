This repository holds the final Ruby on Rails project, an implementation of core Facebook functionality.

I've chosen to do it with a pet theme, so pets will have profile pages and can sent each other likes, etc.


# Plan
Models
- User
- Post
- Comment
- Like
- Connection

Model Associations

A user:

- has many posts
- has many comments_made, inverse_of commenter
- has many comments_received, as commentable
- has many likes_given, inverse of liker
- has many likes_recevied, as likeable
- has many friends through connections

A post

- belongs to a user
- has many likes
- has many comments as commentable (polymorphic)

A comment

- belongs to commenter, class user
- belongs to a commentable (polymorphic association)
- has many comments as commentable

A like

- belongs to a liker, class user
- belongs to likable
- belongs to likeable (polymorphic)

A reqeuest

- belongs to user as sender
- belongs to user as receiver

# Implemention notes
I've implemented two users and posts, and now trying to figure out what the associations for "friends" would be. So, I think first, there is a through assocation. There's the join model (request) which links to users. I ended up leveraging the request join model and a boolean so as to implement the idea of friend as a scope on requests. I ended up implementning both the like and comment as polymorphic associations, so that we can like and comment on anything.

Currently, thinking about how to write specs so that behaviours of the models can be verified automatically.