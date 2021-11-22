# Helpjuice test app

## How I built this app
### Tech stack
* Rails 7.0.0-alpha-2
* PostgreSQL 14
* Hotwire-rails (turbo-rails + stimulus-rails)
* RSpec
* Capybara
* Fabrication
* Faker
* Pundit
* tailwindcss

### Search recording algorithm
A search is not complete unless it ends with a punctuation letter (?!.).
The searches are recorded *almost* in realtime while the user is typing.

Here a pseudo algorithm for the search recording.

Note: A user search can be in one of two statuses
  1. complete: its query ends with a punctiuation
  2. incomplete

```
The user starts typing
if (there is no previous search, i.e. this is the first time the user searched) then
  create a new incomplete search with the user query
else if the previous search is incomplete
  update its `query` field with the new query, regardless of the query
  if (user query is complete)
    set the search as complete
else // previous search is complete
  if (user query is complete, i.e. ends with a punctuation)
    create a new complete search with the user query
  else
    create a new incomplete search with the user query
```
### Frontend
I used Turbo and Stimulus for the search function.

### Code Testing
All the code has been Test Driven. The full stack has been tested with end2end
tests using Capybara. This covers the Stimulus controllers.
With some other tests written as controller specs.

### Users management

Two types of users
1. Guest
2. Admin: only one admin with username **admin** and password **12345**

When the user first visits the app a new User record with role *:guest* is
created and its id is saved in a cookie (:user_id). All searches will be
associated to that user after that.

#### Searches
A *guest* user can see all his completed searches in the searches page, but not
searches of other users.

The *admin* can see searches of all users and his searches are not recorded.

I used pundit for authorization.

### Styles
All pages are styled using Tailwindcss.

### Hostinga
The app is hosetd on **Heroku** under [helpjuice-test-nafaa](https://helpjuice-test-nafaa.herokuapp.com)

### Run Locally

```
bundle
rails db:create db:migrate

# install foreman and run
foreman start

# Run specs
rspec
```
