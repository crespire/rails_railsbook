This repository holds the final Ruby on Rails project, an implementation of core Facebook functionality.

I've chosen to do it with a pet theme, so pets will have profile pages and can sent each other likes, etc.


# Plan
Models
- User
- Post
- Comment
- Like
- Request

Model Associations

A user:

- has many posts
- has many comments
- has many likes
- has many requests_sent
- has many requests_received

A post

- belongs to user
- has many likes
- has many comments

A comment

- belongs to user
- belongs to post

A like

- belongs to a liker, class user
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

**May**
Having considered how to approach nested comments, I think it's a little bit more complicated than I want to get on this project. I've decided to approach comments are a nested child resource of post, and stick with that for the meantime.

Nested comments seemed to be difficult to implement on the view side without causing a bunch of N+1 problems. Not a trivial task. I am not well versed enough in the Rails framework (yet!!) to come up with a good solution for it, and I think having posts with just one level of comments is sufficient. I also still want to keep Likes as a polymorphic model, so I will still have some exposure to using them in the project.

Running into an issue with my Post/Comment association. I'm having issues either executing a Post destroy due to comment assocations, or having issues adding comments. Think on this a little bit.

I've updated the readme to reflect the changes in my approach for my models.

Resolved my dependent destroy issue. I was using `counter_cache` on the wrong side of my association. It belongs to the `belongs_to` side. D'oh. Now, the task today is to sort out how to update a post's comments using Turbo, as new comments are committing correctly, but not updating in the view.

**June**
Working now on requests between users. The associations and model seem to work as I expect in the console, so now the challenge is to build the controller and the views to support the functionality.

I think the approach should be that you have a requests "hub" that show your pending requests, and also a list of accepted requests. I am not sure how I should handle initiating requests. Should I have it where you can see another user's posts and have the option to friend them if they are not already your friend? This way, I can maybe style a friend's posts differently than if they are not your friend?

Or should I have a list of users that you can browse and can send requests that way? I think the way Facebook does it, is that you can look up a user via search, and then from their profile page, you can send them a request. I've got this set up where I have a `user#show` path, so perhaps this is the way to go.

This would mean that I should implement:
* A user collection search
* A user#show view

Then after those are done, I can work on the requests.

Having completed a basic user search and the user#show view to accompany it, I think it's a good time to write some tests for it. I probably don't need to do system tests, and would probably just do some request specs to verify some test cases.

The next step here is to work on the Requests controller and required views for it. I currently have requests working on the console, so it's a matter of fleshing the system out, then writing some tests for it.

I am thinking I should utilize some sort of join model for "friends" instead of utilizing a query on the user model here, so I will have to re-think some of my associations.

Ideally, I should be able to call `current_user.friends` with scopes `pending` and `accepted` - similiar to my requests right now. So I think I'll have to have a think about how to accomplish that.

Currently have friends working in a "one way" basis. The requestor/sender side works, but I am not sure how to make sure the other side (receiver) also work. Thinking on it...

~~I have decided to utilize callbacks to generate two join models for each friendship, with callbacks to also keep their status in sync. This way, when a user initiates a request, an inverse request is generated. The same goes for when a status changes, or when a record is destroyed. I have indexed the requests so that they are unique by user/friend id, which means you can only friend the person once. I prefer this approach as SQL is fast and cheap, and it means my associations can be simple-ish, and I am able to add pending friends by using the shovel operator on friends. I don't get `current_user.friends.pending` but I do get `current_user.friends` and `current_user.pending_friends`. I do get to use scopes with the `current_user.requests` association though, which should be good enough for me for now.~~

As an update, I have decided against the "mirrored" relationship approach. While it seems fine in concept, I think it will have problems at scale, both relying on callbacks that get triggered for each transaction, and how quickly the data might grow as you add users. I know this is essentially a toy app, so that won't be something I have to really worry about, but I still think it's worth thinking at that scale as an exercise.

I've stuck with the bi-furcated associations approach, and added a few custom methods to my User model to consolidate the associations into a single method call. This is similiar to how I was doing it previously, but instead of writing queries in the custom methods, I am leveraging Rails associations.

I've got the Request controller fleshed out (I think), with the key elements I need to make sure requests can be created. I think a "TDD" approach here would be helpful, because I have to think about how I want the over all system to work (in terms of where users can request friends, etc), then build out the testing to support the views, etc.

It will be interesting to see how I can do all fo this with Turbo. 


#Post Script

I originally also took out the second on long term implementation goals, but I am going to put it back here so that I don't forget about important features I'd like to implement.

Features List to be implemented:
* Friend requests and displays (current task)
* Likes system
* Notifications for requests, likes and comments
* Omniauth using two end points (remember to turn off Turbo for these links, as we are not sending ajax requests)
  * Twitter
  * Google
