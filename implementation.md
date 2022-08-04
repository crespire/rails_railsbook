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

I've got the Requests/Friend system working as I want, so now it is time to move on to the likes system. I think doing likes next is good, as then I can just bolt on a notifcation system to all the moving parts after liking is completed.

In terms of the like system:
* You can like a post or comment from other users
* ~~You cannot like your own posts or comments~~

Basically, a user owns a like, and the target is a post or comment (polymorphic). Each post or comment should keep a cache of its like count.

Thinking about how to implement likes, I think having a route concern to pass in an option for the like controller is the way to go. This way, I have a path helper to pass in the ID of the likeable, and the likeable type as an option I can reference in the controller.

I think the first thing to take care of is to check if the current user has already liked the given resource. I feel like this belongs in the User model. Something like:

```ruby
def already_liked?(resource)
  Like.where(liked_by: self.id, likeable_type: resource.class.to_s, likeable_id: resource.id).exists?
end
```

I feel like this is a logical method: when I have a view, I want to check if the user has liked this partiuclar resource. If they have, show a delete option, otherwise they can like the resource. The more I think about it, why not allow a user to like their own stuff?

Having sorted out the routes and the options, I think the rest is fairly simple. Check if the user has already liked the resource. If not, show a link to Like#create. Otherwise, show a link to Like#destroy.

I've added liking and unliking on the comment partial, but I would like for the counts and actions to update in real time, so it seems like I'll have to fiddle around with a turbo frame! I think I will work on this until it's good, then port it over to the post like button.

Completed like/unlike on Post and Comment resources. I am not 100% sure I implemented them in the best way possible, but I am happy with how it works. My next step is to write an automated system test suite.

This will require I figure out how to use factories with nested assocations as well.

After that, I think I can move on to basic notifications, and get that working/tested. Then after that we're in the home stretch with CSS BEM styling and adding avatars, etc.

I've completed the testing for the like system, so now it's time to move on to the notification system.

Thinking about how the notification system should work, basically we will have an index action, create, and "read" action.

Any action like sending a request or sending a like will create a notification. In the case of requests, the receiving party will have a notification. In the case of likes, the liked resource's owner will have a notification.

Then we index all notifcations that are not seen and bunch them first. Any time we load a notfication on the index, we update it to "seen" - then we only count "unseen" ones (this can be accomplished with a scope).

Having worked through a bit, there are three cases in the app where I have to send a notification:
* You receive a request
* Your post receives a comment
* Your post or comment receives a like

Request is easy, once a request is created, also create a Notification belonging to the receiver, type: request, triggered by sender.

Comment received is a little trickier. On comment create, also create notification belonging to the post owner, type: comment, triggered by commenter.

Like received. On like create, also create notification belonging to the resource's owner, type: like, triggered by liked_by.

Generally then, each Notifiable has:
* Target: which can be parent resource's owner, or sender
* Type: resource's class
* Triggered by: resource's owner

I ended up swapping off using callbacks (primarily) and going with a concern approach. I still use one callback (`after_save`) to populate the information I need for the notification details, and have the details memoized so that it doesn't have to pull that information again unless the `notify` is called some time after an object's save (which I don't think would be the case).

This way, any time a notifiable resource is saved, in its controller, there is a call to `resource.notify` that generates the correct notification for said resource.

The testing is done for the project as of this point, so that is good.

My next step is to explore Omniauth, and my goal is to enable Twitter and Google for this toy app. After that, I will probably write some simple request tests related to Omniauth, as I think it'll be a good opportunity to flex the mocks/stubs muscle again (haven't used them since Chess!).

Adding real time notification count updates took a bit more brain flex than I had anticipated, but I got it working! Now we can move on to Omniauth.

Finished omniauth! I ended up adding Github and Google, rather than Twitter and Google, but it seems relatively simple to add another provider if I want.

Now to style the whole thing, which I think will be a little overwhelming. I've already got some of the scafolding done in terms of CSS, all my own generated views follow (somewhat) the BEM methodology with namespacing.

l = layout
c = component

Then it's just block__element-modifier. I think I should first look into the asset pipeline and figure out how to parse SCSS, as it has not really been something I've been doing until now.

See Github issues, migrating to that.

#Post Script

I originally also took out the second on long term implementation goals, but I am going to put it back here so that I don't forget about important features I'd like to implement.

Features List to be implemented:
* BEM CSS styling
