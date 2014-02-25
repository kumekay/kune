class SubscriptionWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: "default"


  def perform(article_id)
    # Select only one  category/user pair for notification
    article=Article.includes(:categories).find(article_id)
    categories = article.categories.pluck(:id)
    subscriptions =Subscription.where(category_id: categories) \
                               .includes(:user, :category) \
                               .map{|s| {email: s.user.email, \
                                         name: s.user.name,\
                                         category: s.category.title,
                                         key: s.security_key}}\
                               .uniq { |s| s[:email] }
    subscriptions.each do |info|
      logger.info info
      SubscriptionMailer.delay.subscription_email(article, info)
    end
  end
end