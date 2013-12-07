# ShopTwo

Course CG3002 Server-side, built with Ruby on Rails. [Some screenshots in Wiki](https://github.com/zhuochun/shopTwo/wiki)

# Prerequisite

- Ruby 2.0.0-p247
- Rails 4.0.1
- PostgreSQL Mac: [App](http://postgresapp.com/), Win: [Download](http://www.postgresql.org/download/)

# Setup Local Machine

- `bundle install`
- `rake db:create`
- `rake db:migrate`
- `rake db:seed` seed default stores and accounts
- `rake import:dev` import small inventories (size 100), and one store's stocks
- `rake import:prod_test` import standard inventories (size 5000), and 1 store's stocks + transactions
- `rails server`

# Setup on Heroku

- `heroku create`
- `git push heroku master`
- `heroku pg:reset DATABASE` if necessary
- `heroku run rake db:migrate`
- `heroku run rake db:seed` seed default stores and accounts
- `heroku run rake import:prod_test` import standard inventories (size 5000), and 1 store's stocks + transactions
- `heroku run rake import:prod_demo` import standard inventories (size 5000), and 5 stores' stocks + transactions
- `heroku ps:scale web=1`
