Rails.configuration.stripe = {
  :publishable_key => "pk_test_6pRNASCoBOKtIshFeQd4XMUh", #ENV['PUBLISHABLE_KEY'],
  :secret_key      => "sk_test_BQokikJOvBiI2HlWgH4olfQ2" #ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]