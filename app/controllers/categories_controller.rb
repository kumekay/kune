class CategoriesController < ApplicationController
  def show
    @category =  Category.find(params[:id])
    @articles = @category.articles.approved.page params[:page]
    render "articles/index"
  end
end