class CheckoutController < ApplicationController
  def create
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      mode: 'subscription',
      line_items: [{
        price: params[:price_id],
        quantity: 1
      }],
      success_url: root_url + '?success=true',
      cancel_url: root_url + '?canceled=true'
    )

    redirect_to session.url, allow_other_host: true
  end
end
