Rails.configuration.stripe = {
  publishable_key: ENV['pk_test_HCHMD7DrboQjiTbNTkKq8wTL'],
  secret_key:      ENV['sk_test_Tj9A7YTOvsJj4zdj4zldpzKf']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
