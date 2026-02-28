const API_BASE_URL = "http://localhost:3001/api/v1";

async function apiRequest(path, options = {}, token = null) {
  const headers = {
    "Content-Type": "application/json",
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
    ...(options.headers || {})
  };

  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...options,
    headers
  });

  const data = await response.json().catch(() => ({}));
  if (!response.ok) {
    throw new Error(data.error || "API request failed");
  }

  return data;
}

async function registerUser(name, email, password) {
  return apiRequest("/auth/register", {
    method: "POST",
    body: JSON.stringify({
      user: {
        name,
        email,
        password,
        password_confirmation: password
      }
    })
  });
}

async function loginUser(email, password) {
  return apiRequest("/auth/login", {
    method: "POST",
    body: JSON.stringify({ email, password })
  });
}

async function generateItinerary({ budget, days, tripType, notes }, token = null) {
  return apiRequest("/itineraries", {
    method: "POST",
    body: JSON.stringify({
      itinerary: {
        budget,
        days,
        trip_type: tripType,
        notes
      }
    })
  }, token);
}

async function createBooking({ itineraryId, tourId, startDate, endDate, guests, totalAmount, specialRequests }, token) {
  return apiRequest("/bookings", {
    method: "POST",
    body: JSON.stringify({
      booking: {
        itinerary_id: itineraryId,
        tour_id: tourId,
        start_date: startDate,
        end_date: endDate,
        guests,
        total_amount: totalAmount,
        special_requests: specialRequests
      }
    })
  }, token);
}

async function createPaymentIntent(bookingId, token) {
  return apiRequest("/payments/create_intent", {
    method: "POST",
    body: JSON.stringify({ booking_id: bookingId })
  }, token);
}

async function listPaymentTransactions(token) {
  return apiRequest("/payment_transactions", {
    method: "GET"
  }, token);
}

window.ZanzibarApi = {
  registerUser,
  loginUser,
  generateItinerary,
  createBooking,
  createPaymentIntent,
  listPaymentTransactions
};
