class CategoriesController < ApplicationController
  def show

    # Load subscription
    @subscription = Subscription.find_by(user_id: current_user.try(:id), category_id: params[:id])

    @category =  Category.find(params[:id])
    @articles = @category.articles.approved.page params[:page]
    render "articles/index"
  end
end