class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy, :upvote, :downvote]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  def new
    @article = Article.new
  end

  def index
    @articles=Article.paginate(page: params[:page], per_page: 5).order(:cached_votes_score => :desc)
  end

  def edit

  end

  def create

    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "El articulo ha sido creado exitosamente"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def update

    if @article.update(article_params)
      flash[:success] = "El articulo se actualizo correctamente"
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def show

  end

  def destroy

    @article.destroy
    flash[:danger] = "El articulo fue borrado exitosamente"
    redirect_to articles_path
  end

  def upvote
    @article.upvote_from current_user
    redirect_to article_path(@article)
  end

  def downvote
    @article.downvote_from current_user
    redirect_to article_path(@article)
  end
  private
    def set_article
      @article= Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :description, category_ids: [])
    end

    def require_same_user
      if current_user != @article.user and !current_user.admin?
        flash[:danger] = "Solo puedes editar o eliminar tus articulos"
        redirect_to root_path
      end
    end
end
