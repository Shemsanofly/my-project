admin = User.find_or_create_by!(email: "admin@zanzibar.tours") do |user|
  user.name = "Admin"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.admin = true
end

itinerary = Itinerary.find_or_create_by!(user: admin, days: 4, budget: 1200, trip_type: "adventure") do |record|
  record.content = {
    overview: "4-day Zanzibar adventure",
    daily_plan: [
      "Stone Town walking tour",
      "Jozani Forest and spice farm",
      "Mnemba snorkeling",
      "Sunset dhow cruise"
    ]
  }.to_json
end

tour = Tour.find_or_create_by!(title: "Stone Town + Mnemba Escape", duration_days: 4, trip_type: "adventure") do |record|
  record.description = "Historic Stone Town, snorkeling at Mnemba Atoll, and a sunset dhow cruise."
  record.price = 899.00
  record.active = true
end

Booking.find_or_create_by!(user: admin, itinerary: itinerary, start_date: Date.today + 14, end_date: Date.today + 18) do |booking|
  booking.status = "pending"
  booking.guests = 2
  booking.total_amount = 1500.00
  booking.tour = tour
  booking.special_requests = "Airport transfer included"
end
