ActiveAdmin.register Article do
  permit_params :title, :summary, :body, :user_id, categories: [:title]
  scope :fresh
  scope :declined
  scope :approved

  # Add approve action for article
  member_action :approve do 
    article = Article.find(params[:id])
    if article.approve
      redirect_to admin_articles_path, notice: t("active_admin.approve.successfully_approved")
    end
  end

  member_action :decline do 
    article = Article.find(params[:id])
    if article.decline
      redirect_to admin_articles_path, notice: t("active_admin.decline.successfully_declined")
    end
  end


  index as: :blog do
    title do |article|
      span article.title, class: 'title'
    end
    body do |article|
      div raw( article.summary)
      div  do
        if article.approved? 
          span (t '.published', ago: distance_of_time_in_words_to_now( article.approved_at )), class: 'status_tag'
        else
          span t('.not_published'), class: 'status_tag'
        end  
        # span article.user.try(name)
      end
      div do
        if article.fresh?
          span link_to(t("active_admin.articles_actions.approve"), approve_admin_article_path(article)) 
          span '|'
          span link_to(t("active_admin.articles_actions.decline"), decline_admin_article_path(article)) 
        end
      end
    end

  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs :title
    f.inputs  do
      f.input :summary
    end
    f.inputs  do
      f.input :body
    end

    f.inputs :approved

    f.inputs do
      f.has_many :categories do |cf|
        cf.input :title
      end
    end

    f.inputs :user
    f.actions
  end
end
