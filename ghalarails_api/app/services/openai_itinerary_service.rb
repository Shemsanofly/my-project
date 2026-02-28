class OpenaiItineraryService
  class ServiceError < StandardError; end

  OPENAI_URL = "https://api.openai.com/v1/responses".freeze

  def generate(budget:, days:, trip_type:, notes: nil)
    response = Faraday.post(OPENAI_URL) do |req|
      req.headers["Authorization"] = "Bearer #{ENV.fetch("OPENAI_API_KEY")}" 
      req.headers["Content-Type"] = "application/json"
      req.body = {
        model: ENV.fetch("OPENAI_MODEL", "gpt-4o-mini"),
        input: prompt(budget: budget, days: days, trip_type: trip_type, notes: notes)
      }.to_json
    end

    parsed = JSON.parse(response.body)
    text = parsed["output_text"].presence || parsed.dig("output", 0, "content", 0, "text")

    raise ServiceError, "OpenAI response is empty" if text.blank?

    text
  rescue KeyError => error
    raise ServiceError, "Missing configuration: #{error.message}"
  rescue StandardError => error
    raise ServiceError, "Failed to generate itinerary: #{error.message}"
  end

  private

  def prompt(budget:, days:, trip_type:, notes:)
    <<~PROMPT
      Create a Zanzibar travel itinerary in JSON format with keys: overview, daily_plan, estimated_cost_breakdown, and tips.
      Budget (USD): #{budget}
      Number of days: #{days}
      Trip type: #{trip_type}
      Extra notes: #{notes.presence || "none"}
      Keep recommendations practical and location-specific for Zanzibar.
    PROMPT
  end
end
