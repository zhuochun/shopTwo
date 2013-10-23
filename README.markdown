# ShopTwo

CG3002 Course Server-side, Ruby on Rails.

# Prerequisite

- Ruby 2.0.0
- Rails 4.0.0
- [PostgreSQL](http://www.postgresql.org/download/), Mac: <http://postgresapp.com/>

# Setup Local Machine

- `bundle install`
- `rake db:setup`
- `rake db:migrate`
- `rake db:seed`
- `rails server`

# Setup on Heroku

- `heroku create`
- `git push heroku master`
- `heroku pg:reset DATABASE` if necessary
- `heroku run rake db:migrate`
- `heroku run rake db:seed`
- `heroku ps:scale web=1`