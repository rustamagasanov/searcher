class HomeController < ApplicationController
  def index
  end

  def search
    @results = SearchService.new(params[:q]).run
  end
end
