class ChargesController < ApplicationController

  def new
  end

  def create
    # Amount in cents
    @amount = 10000

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card  => params[:stripeToken]
    )
    current_user.update(:customer_id => customer.id)

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => current_user.name,
      :currency    => 'usd'
    )


  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

end
