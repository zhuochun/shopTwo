# ShopTwo

Course CG3002 Server-side, built with Ruby on Rails.

# Prerequisite

- Ruby 2.0.0-p247
- Rails 4.0.1
- PostgreSQL Mac: [App](http://postgresapp.com/), Win: [Download](http://www.postgresql.org/download/)

# Setup Local Machine

- `bundle install`
- `rake db:create`
- `rake db:migrate`
- `rake db:seed` default stores and accounts
- `rake import:dev` create default inventories (size 100)
- `rails server`

# Setup on Heroku

- `heroku create`
- `git push heroku master`
- `heroku pg:reset DATABASE` if necessary
- `heroku run rake db:migrate`
- `heroku run rake db:seed` create default stores and accounts
- `heroku run rake import:production` create default inventories (size 5000)
- `heroku ps:scale web=1`
