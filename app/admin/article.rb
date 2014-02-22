ActiveAdmin.register Article do
  permit_params :title, :summary, :body, :approved, categories: [:title]
  scope :unapproved
  scope :approved

  # Add approve action for article
  member_action :approve, method: :patch do 
    article = Article.find(params[:id])
    # redirect_to {action: :show}, {notice: t(".successfully_approved")}
  end

  index as: :blog do
    title do |article|
      span article.title, class: 'title'
  
      # span {}
    end
    body do |article|
      div  do
        if article.approved? 
          span (t '.published', ago: distance_of_time_in_words_to_now( article.approved_at )), class: 'status_tag'
        else
          span t('.not_published'), class: 'status_tag'
        end  
      end
      div raw( article.summary)
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
    f.actions
  end
end
