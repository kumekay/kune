ActiveAdmin.register Article do
  permit_params :title, :summary, :body, :user_id, category_ids: []
  scope :fresh
  scope :declined
  scope :approved

  # Add approve action for article
  member_action :approve do 
    article = Article.find(params[:id])
    if article.approve
      # Send notification
      NotificationMailer.delay.article_approved_email(article)

      # Send article to subscribers
      SubscriptionWorker.perform_async(article.id)
      

      redirect_to admin_articles_path, notice: t("active_admin.approve.successfully_approved")
    else
      redirect_to admin_articles_path, alert: t("active_admin.approve.not_approved")
    end
  end

  member_action :decline do 
    article = Article.find(params[:id])
    if article.decline
      # Send notification
      NotificationMailer.delay.article_declined_email(article)
      
      redirect_to admin_articles_path, notice: t("active_admin.decline.successfully_declined")
    else
      redirect_to admin_articles_path, alert: t("active_admin.decline.not_declined")
    end
  end


  index do 
    column :title do |article|
      link_to article.title, admin_article_path(article)     
    end 

    column :summary do |article|
      raw article.summary
    end
    column t('.state') do |article|
 
      if article.fresh?
        span link_to(t("active_admin.articles_actions.approve"), approve_admin_article_path(article)) 
        span link_to(t("active_admin.articles_actions.decline"), decline_admin_article_path(article)) 
      elsif article.approved? 
        status_tag t('.published', ago: time_ago_in_words( article.approved_at ))
      else
        status_tag t('.declined')
      end  
    end

    actions 
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs  do
      f.input :title
      f.input :summary, input_html: {class: "tiny_redactor" }, label: false
      f.input :body , input_html: {class: "redactor" }, label: false
      f.input :categories, as: :check_boxes
      f.input :tag_list
    end

    f.inputs :user
    f.actions
  end

  show do |article|
    h3 article.title
    div do
      raw article.body
    end
  end
end
