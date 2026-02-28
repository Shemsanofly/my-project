class WhatsappNotificationService
  class ServiceError < StandardError; end

  def send_text(phone_number:, message:)
    return if ENV["GHALARAILS_WHATSAPP_API_BASE"].blank? || ENV["GHALARAILS_WHATSAPP_API_KEY"].blank?

    url = ENV.fetch("GHALARAILS_WHATSAPP_API_BASE")
    api_key = ENV.fetch("GHALARAILS_WHATSAPP_API_KEY")

    response = Faraday.post(url) do |req|
      req.headers["Authorization"] = "Bearer #{api_key}"
      req.headers["Content-Type"] = "application/json"
      req.body = {
        to: phone_number,
        type: "text",
        text: {
          body: message
        }
      }.to_json
    end

    raise ServiceError, "WhatsApp API request failed" unless response.success?
  rescue KeyError => error
    raise ServiceError, "Missing configuration: #{error.message}"
  rescue StandardError => error
    raise ServiceError, "WhatsApp notification failed: #{error.message}"
  end
end
