class NotificationMailer < ActionMailer::Base
  default from: 'notifications@example.com'

  def article_approved_email(article)
    @user = article.user
    @article  = article
    mail(to: @user.email)
  end

  def article_declined_email(article)
    @user = article.user
    @article  = article
    mail(to: @user.email)
  end
end
