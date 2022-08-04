# Railsbook

This is my implementation of basic Facebook functionality leveraging Rails 7 and its associated technologies. This application includes:
* Friends and requests
* Posts and comments with ActionText powering the attachments via ActiveStorage and Amazon S3.
* Notifications
* Likes
* User authentication and Oauth through the devise gem

You can find a live link in the repository's about section, if you wish to give it a spin.

# Key Learning

This project felt very large at first, but going through and building functionality step by step and building on previous iterations of the app was what helped me to finally accomplish what I wanted to accomplish.

* One achievement of mine was leveraging the idea of nested resources which I had not looked into before this project. With requests and comments being resources that always belonged to a parent, it was the perfect opportunity to explore how I could leverage Rails magic to my advantage.

* This project really challenged my knowledge of Rails associations and ActiveRecord intricacies which is an area that I continue to have a lot of learn about. I was happy I was able to execute the `Like` resource without much fuss.

* Another first was using a model concern, which took a bit for me to figure out how to use effectively. In the end, I am happy I was able to take this approach and it helped to keep the application DRY-er than it would have been otherwise.

* Writing a custom validator for particular resources was also new to me, but with my built up level of comfort in the API documentation, I was able to figure out how to work things.

* Another big challenge for me was to translate my testing knowledge and experience in plain old Ruby RSpec into a Rails context. Once I figured out how to utilize RSpec and Capybara I was able to find my rhythm and really make sure my features and systems were at least covered by tests. I didn't strictly TDD this project, but I knew that having a test suite for key systems was important if I ever wanted to work on this project more to add other features or improve the internals in the future. Leveraging Faker and FactoryBot in testing was also new to me, and it was very satisfying to figure out how to leverage those gems to make testing easier.

* This project also marked the first time I styled a big Rails project of mine. While I had the opportunity to leverage a framework like Tailwind, Bulma or Bootstrap, I decided to flex my skills and stick with SCSS and BEM methodology. I would say the design is acceptable, but I think I could have gotten a more interesting design had I gone with a framework. That being said, using SCSS and BEM did teach me a lot, so I am happy with the choice I made.

# Future Opportunities
There are a few things I left on the table in terms of this application that I would love to revisit in the future when I don't have other things I'm keen to learn or pick up.

* Users created from Oauth are currently not able to edit their profiles. This is a pretty big deal, especially if they want to add supplementary information. Work to fix this would involve modifying the User model and making some changes to the Devise Oauth flow, then updating my edit user flow to accommodate these changes.

* Leverage a CSS framework to make the application design a little less wonky. I think with a standardized CSS framework, I might have made different choices in my design. Definitely something to explore in another project.

# About Me
Visit [my about page](https://crespire.net/) to learn more about what I'm up to and how to contact me.