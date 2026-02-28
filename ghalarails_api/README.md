# GhalaRails API (Zanzibar Tourism Backend)

Rails API backend for your existing Zanzibar Tourism frontend.

## Features

- AI itinerary generation (`OpenAI`) based on budget, days, and trip type.
- Booking CRUD and tour catalog endpoints.
- Stripe payment intent + webhook support.
- Transaction ledger (`payment_transactions`) for audit and tracking.
- JWT authentication (register/login).
- Admin endpoints for tour management.
- Optional WhatsApp/GhalaRails message notification after successful payment.
- PostgreSQL models for users, tours, itineraries, and bookings.
- CORS + JSON error handling + request logging middleware.

## 1) Requirements

- Ruby 3.2+
- Rails 7.1+
- PostgreSQL 14+
- Bundler

## 2) Setup

```bash
cd ghalarails_api
cp .env.example .env
bundle install
rails db:create db:migrate db:seed
rails s -p 3001
```

## 3) Environment Variables

Set these in `.env` or your deployment platform:

- `OPENAI_API_KEY`
- `OPENAI_MODEL` (default `gpt-4o-mini`)
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `JWT_SECRET`
- `GOOGLE_MAPS_API_KEY` (optional)
- `FRONTEND_ORIGIN` (e.g. `http://127.0.0.1:5500`)
- `GHALARAILS_WHATSAPP_API_BASE` (optional)
- `GHALARAILS_WHATSAPP_API_KEY` (optional)
- `DEFAULT_CUSTOMER_WHATSAPP` (optional)
- PostgreSQL vars (`DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`)

## 4) API Endpoints (v1)

Base URL: `http://localhost:3001/api/v1`

### Health

- `GET /health`

### Auth

- `POST /auth/register`
- `POST /auth/login`

### Tours

- `GET /tours`
- `GET /tours/:id`

### Itineraries

- `POST /itineraries` (guest or authenticated)
- `GET /itineraries` (authenticated)
- `GET /itineraries/:id` (authenticated owner)

### Bookings (authenticated)

- `GET /bookings`
- `POST /bookings`
- `GET /bookings/:id`
- `PATCH /bookings/:id`
- `DELETE /bookings/:id`

### Payments

- `POST /payments/create_intent` (authenticated)
- `POST /payments/webhook` (Stripe)

### Payment Transactions (authenticated)

- `GET /payment_transactions`
- `GET /payment_transactions/:id`

### Admin (authenticated admin only)

- `GET /admin/tours`
- `POST /admin/tours`
- `GET /admin/tours/:id`
- `PATCH /admin/tours/:id`
- `DELETE /admin/tours/:id`

## 5) Frontend Integration

Use `../frontend_api_examples.js` from your existing HTML pages and call:

- `ZanzibarApi.registerUser(...)`
- `ZanzibarApi.loginUser(...)`
- `ZanzibarApi.generateItinerary(...)`
- `ZanzibarApi.createBooking(...)`
- `ZanzibarApi.createPaymentIntent(...)`
- `ZanzibarApi.listPaymentTransactions(...)`

## 6A) Connect GhalaRails/WhatsApp Business Dashboard

1. In your GhalaRails Business dashboard, complete the **Connect WhatsApp** flow.
2. Copy your messaging API base URL and API key from dashboard credentials.
3. Set `GHALARAILS_WHATSAPP_API_BASE` and `GHALARAILS_WHATSAPP_API_KEY` in backend env.
4. Set `DEFAULT_CUSTOMER_WHATSAPP` for test notifications.
5. Trigger Stripe success flow; backend sends confirmation message automatically.

## 6) Deploy (Render example)

1. Push repository to GitHub.
2. Create PostgreSQL on Render.
3. Create new **Web Service** from repo, root dir: `ghalarails_api`.
4. Build command: `bundle install && bundle exec rails db:migrate`.
5. Start command: `bundle exec puma -C config/puma.rb`.
6. Add all env vars from `.env.example` in Render dashboard.
7. Update `FRONTEND_ORIGIN` to your frontend domain.
8. Point frontend `API_BASE_URL` to deployed API URL.

## 7) Production Notes

- Keep secrets only in environment variables (never commit real keys).
- Rotate API keys periodically.
- Use HTTPS only.
- Configure Stripe webhook endpoint to `/api/v1/payments/webhook`.
- Monitor logs and add rate limiting (`Rack::Attack`) if traffic grows.
