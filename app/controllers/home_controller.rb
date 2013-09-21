class HomeController < ApplicationController
  def index
    render text: "Hello Heroku!"
  end
end
