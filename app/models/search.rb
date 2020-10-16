class Search < ApplicationRecord
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

  def global_search(query)
    puts "Searching both Google and Bing for: " + query
    google_results = google_search(query)
    bing_results = bing_search(query)
    return google_results + bing_results
  end
end
