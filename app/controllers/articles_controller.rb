class ArticlesController < ApplicationController
  before_action :authenticate_user!,
only: [ :new, :create, :edit, :update, :destroy, :bookmarks, :bookmark, :unbookmark ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy, :bookmark, :unbookmark ]

  def index
    @q = Article.ransack(params[:q])
    @articles = params[:q].present? ? @q.result(distinct: true) : Article.all
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to @article, notice: "記事を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "記事を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "記事を削除しました。"
  end

  def bookmarks
    if user_signed_in?
      @bookmarked_articles = current_user.bookmark_articles.includes(:user).order(created_at: :desc)
    else
      redirect_to new_user_session_path, alert: 'ブックマーク一覧を見るにはログインが必要です'
    end
  end

  def bookmark
    current_user.bookmark(@article)
    respond_to do |format|
      format.html { redirect_to @article, notice: 'ブックマークしました' }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark_button_#{@article.id}",
                                  partial: 'bookmark_button',
                                  locals: { article: @article }) }
    end
  end

  def unbookmark
    current_user.unbookmark(@article)
    respond_to do |format|
      format.html { redirect_to @article, notice: 'ブックマークを解除しました' }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark_button_#{@article.id}",
                                  partial: 'bookmark_button',
                                  locals: { article: @article }) }
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
