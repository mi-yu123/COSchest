class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    # プロフィールを作成後にコメントアウトを外す
    # @articles = Article.includes(:user)
  end
end
