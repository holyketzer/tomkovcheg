class CategoriesController < ApplicationController
  respond_to :html
  inherit_resources
  authorize_resource

  layout 'two_columns', only: [:new, :edit, :index]

  def new
    @category = Category.new
    @category.build_image
  end

  def edit
    edit! { @category.build_image unless @category.image }
  end

  def index
    @categories = Category.order(:priority)
  end

  def create
    create!(notice: t('activerecord.successful.messages.category_saved'))
  end

  def update
    update!(notice: t('activerecord.successful.messages.category_saved'))
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.visible.page params[:page]
  end

  private
    def build_resource_params
      [params.fetch(:category, {}).permit(:title, :description, :priority, image_attributes: [:id, :imageable_id, :source])]
    end
end
