class SearchController < ApplicationController
  def index
    
    if(params.has_key?(:engine) && params.has_key?(:query))
      @engine = params[:engine]
      @query = params[:query]
      results = []

      if @engine == "google"
        results = google_search(@query)
      elsif @engine == "bing"
        results = bing_search(@query)
      elsif @engine == "both"
        results = global_serch(@query)
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

  def google_search(query)
    puts "Searching Google for: " + query
    results = GoogleCustomSearchApi.search(URI.escape(query))
    return results['items']
  end

  def bing_search(query)
    accessKey = "5fd835e180274be7840a8a8ea434d611"
    uri  = "https://api.cognitive.microsoft.com"
    path = "/bing/v7.0/search"

    uri = URI(uri + path + "?q=" + URI.escape(query))
    puts "Searching Bing for: " + query

    request = Net::HTTP::Get.new(uri)
    request['Ocp-Apim-Subscription-Key'] = accessKey

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    json_response = JSON.parse response.body
    return json_response['webPages']['value']
  end

  def global_serch(query)
    puts "Searching both Google and Bing for: " + query
    google_results = google_search(query)
    bing_results = bing_search(query)
    return google_results + bing_results
  end
end
