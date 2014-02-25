class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: :subscribe

  def subscribe
    @subscription = Subscription.new
    @subscription.user_id = subscription_params[:user_id]
    @subscription.category_id = subscription_params[:category_id]

    if @subscription.save
      redirect_to @subscription.category, notice: t('subscriptions.subscribe.successfully_saved')
    else
      redirect_to @subscription.category, error: t('subscriptions.subscribe.couldnot_save')
    end
  end

  def unsubscribe
    @subscription = Subscription.find_by(security_key: subscription_params[:security_key])

    # If subsctiption and deleted
    if @subscription.try(:destroy)
      redirect_to @subscription.category, notice: t('subscriptions.unsubscribe.successfully_saved')
    elsif @subscription
      redirect_to @subscription.category, error: t('subscriptions.unsubscribe.couldnot_save')
    else
      redirect_to :root, error: t('subscriptions.unsubscribe.couldnot_save')
    end 
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    params.permit(:subscription,:user_id, :category_id, :security_key)
  end
end
