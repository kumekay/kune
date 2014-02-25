class SubscriptionMailer < ActionMailer::Base
  default from: "subscription@example.com"

  def subscription_email(article, info)
    @info = info
    @article  = article
    mail(to: @info[:email], subject: t(".subject", category: @info[:category], name: @info[:name] ) )
  end
end
