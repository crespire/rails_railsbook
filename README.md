# Railsbook

This is my implementation of basic Facebook functionality leveraging Rails 7 and its associated technologies. This application includes:
* Friends and requests
* Posts and comments with ActionText powering the attachments via ActiveStorage and Amazon S3.
* Notifications
* Likes
* User authentication and Oauth through the devise gem
* Rspec testing suite with ~83% coverage

You can find a live link in the repository's about section, if you wish to give it a spin.

## Key Learning

This project felt very large at first, but going through and building functionality step by step and building on previous iterations of the app was what helped me to finally accomplish what I wanted to accomplish.

* Utilized nested resources where it made sense to simplify routing and associations.
* Dove into Rails ActiveRecord and implemented a number of relations that had previously seemed difficult.
* Leveraged a Rails concern to keep the application DRY.
* Wrote a custom Rails validator, demonstrating a level of comfort with the Rails API documentation.
* Developed an RSpec test suite in the Rails context. Learned to use supporting gems Faker and Capybara to implement the test suite. While I didn't strictly TDD this project, testing remained important.
* Rolled custom CSS based the BEM methodology based on a tutorial resource.
* Deployment is hard! While local development and test environments were already using PostgreSQL, getting the app deployed took quite a bit of trial and error, troubleshooting and searching the internet. From adjustments in the production environment to making sure all the services required were running and reachable, I learned a lot about Heroku/dokku, AWS S3, Sendgrid and Oauth.

# Deployment notes
This app relies on `libvips` for image manipulation, which needs to be added to the environment as an available library. In order to build and deploy this application successfully on dokku/heroku with `libvips` and supporting libraries available, the following buildpacks are required in this order:
1. https://github.com/heroku/heroku-buildpack-apt.git
1. https://github.com/brandoncc/heroku-buildpack-vips.git
1. https://github.com/heroku/heroku-buildpack-ruby.git

The apt pack allows us to use the `Aptfile` to install packages into the container that we require (libvips, etc). Make sure to consult the `Aptfile` for the list of libraries that must be installed for VIPS to function.

**Note** For lower-spec'd containers (my experience was with the basic DO droplet with 1vcpu, 1gb RAM and 25gb storage), adding a 2GB swap file solved some out of memory errors that caused a `Kill` while trying to deploy with dokku. This problem is avoided if you're on Heroku's platform, as a dyno is pretty beefy compared to the basic DO droplet.

## Future Opportunities
There are a few things I left on the table in terms of this application that I would love to revisit in the future when I don't have other things I'm keen to learn or pick up.

* Users created from Oauth are currently not able to edit their profiles. This is a pretty big deal, especially if they want to add supplementary information. Work to fix this would involve modifying the User model and making some changes to the Devise Oauth flow, then updating my edit user flow to accommodate these changes.
* Leverage a CSS framework to make the application design a little less wonky. I think with a standardized CSS framework, I might have made different choices in my design. Definitely something to explore in another project.

## About Me
Visit [my about page](https://crespire.dev/) to learn more about what I'm up to and how to contact me.