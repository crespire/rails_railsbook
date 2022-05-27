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

Having completed the post system tests and post system (for the most part), I am now shifting to working on comments for posts.

Typically, comments are pretty straight-forward: a post has many comments, and comments belong to a post and a user. But I've taken the route of making comments a polymorphic assocation so that you can comment on comments, etc.

I've set up my model this way, but now I am wondering how I can set up the controller to accomodate this. I have no intention of allowing individual comment views, or have an "index of" comments, as comments require context (ie, a post or the parent comment, which loops back to requiring the post).

I think the first step to sorting out my comments is to make commenting on posts work (via the appropriate controller actions) to confirm that the model/assocaiations are set up correctly.

Once that is done, then I can work on commenting on comments, as I will at least (hopefully) have a basis for starting after getting commenting done.

**May 27**
Having considered how to approach nested comments, I think it's a little bit more complicated than I want to get on this project. I've decided to approach comments are a nested child resource of post, and stick with that for the meantime.

Nested comments seemed to be difficult to implement on the view side without causing a bunch of N+1 problems. Not a trivial task. I am not well versed enough in the Rails framework (yet!!) to come up with a good solution for it, and I think having posts with just one level of comments is sufficient. I also still want to keep Likes as a polymorphic model, so I will still have some exposure to using them in the project.