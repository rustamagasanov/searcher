class HomeController < ApplicationController
  def index
  end

  def search
    # @q = params[:q]
    @results = SearchService.new(params[:q]).run
    render :index
  end
end
