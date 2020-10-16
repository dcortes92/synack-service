class SearchController < ApplicationController
  def index
    
    if(params.has_key?(:engine) && params.has_key?(:query))
      @engine = params[:engine]
      @query = params[:query]
      @search = Search.new()
      results = []

      if @engine == "google"
        results = @search.google_search(@query)
      elsif @engine == "bing"
        results = @search.bing_search(@query)
      elsif @engine == "both"
        results = @search.global_search(@query)
      else
        puts "Unknown engine"
        render json: {
          error: "Unknown search engine parameter. Please use 'google', 'bing', or 'both'."
        }, status: :bad_request
      end

      render json: results
    else
      puts "Missing params"
      render json: {
        error: "Please provide both 'engine' and 'query' params."
      }, status: :bad_request
    end
  end
end
