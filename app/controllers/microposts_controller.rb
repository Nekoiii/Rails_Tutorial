# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  # before_action :set_micropost, only: %i[ show update destroy ]
  before_action :correct_user, only: %i[destroy]

  def index
    @microposts = Micropost.all
  end

  def show; end

  def new; end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])

    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      # setting @feed_items here is for the situation when post fails
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def update
    if @micropost.update(micropost_params)
      render :show, status: :ok, location: @micropost
    else
      render json: @micropost.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    # redirect_back_or_to: https://railsdoc.com/page/redirect_back_or_to
    # equals to:
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
    # redirect_back_or_to(root_url, status: :see_other)
  end

  private

  # def set_micropost
  #   @micropost = Micropost.find(params[:id])
  # end

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    # see_other: Return 303 status code
    redirect_to root_url, status: :see_other if @micropost.nil?
  end
end
