class GoogleMapsService
  class ServiceError < StandardError; end

  BASE_URL = "https://maps.googleapis.com/maps/api/geocode/json".freeze

  def geocode(address)
    api_key = ENV.fetch("GOOGLE_MAPS_API_KEY")

    response = Faraday.get(BASE_URL, { address: address, key: api_key })
    parsed = JSON.parse(response.body)

    raise ServiceError, "No geocoding results" if parsed["results"].blank?

    parsed["results"].first
  rescue KeyError => error
    raise ServiceError, "Missing configuration: #{error.message}"
  rescue StandardError => error
    raise ServiceError, "Google Maps request failed: #{error.message}"
  end
end
