class CatsController < ApplicationController
  before_action :require_logged_in, only: [:new, :create, :edit, :update]
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    cats = current_user.cats
    @cat = cats.where(id: params[:id]).first
    if @cat
      render :edit
    else
      redirect_to cats_url
    end
  end

  def update
    cats = current_user.cats
    @cat = cats.where(id: params[:id])
    unless @cat
      redirect_to cats_url
    end
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end