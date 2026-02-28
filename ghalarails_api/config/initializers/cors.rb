Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("FRONTEND_ORIGIN", "http://127.0.0.1:5500"), "http://localhost:5500"

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: false
  end
end
