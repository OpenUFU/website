class HomeController < ApplicationController
  def index
    render template: "pages/index"
  end
end
