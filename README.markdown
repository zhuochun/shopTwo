# ShopTwo

CG3002 Course Server-side, Ruby on Rails.

# Prerequisite

- Ruby 2.0.0-p247
- Rails 4.0.1
- PostgreSQL Mac: [App](http://postgresapp.com/), Win: [Download](http://www.postgresql.org/download/)

# Setup Local Machine

- `bundle install`
- `rake db:create`
- `rake db:migrate`
- `rake db:seed` default stores and accounts
- `rake import:dev` if you want to have default inventories
- `rails server`

# Setup on Heroku

- `heroku create`
- `git push heroku master`
- `heroku pg:reset DATABASE` if necessary
- `heroku run rake db:migrate`
- `heroku run rake db:seed` default stores and accounts
- `heroku run rake import:production` if you want to have default inventories
- `heroku ps:scale web=1`
