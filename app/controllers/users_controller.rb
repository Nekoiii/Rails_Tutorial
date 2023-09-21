# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy
                                          following followers]
  before_action :correct_user,   only: %i[edit update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    # @user = User.new(user_params)
    @user = User.new(user_params.except(:avatar))
    if user_params[:avatar].present?
      @user.avatar.attach(user_params[:avatar])
    else
      # Using Rails.root to make sure the full path to the default avatar file is correct
      default_avatar_path = Rails.root.join('app', 'assets', 'images', 'avatar-1.jpg')
       # Using io: File.open to open the file and create an IO object to attach the file
      @user.avatar.attach(io: File.open(default_avatar_path), filename: 'avatar-1.jpg')
    end

    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    # Rails.logger.debug "Edit user with ID: #{params[:id]}"
    @user = User.find(params[:id])
  end

  def update
    Rails.logger.debug "Update user with ID: #{params[:id]}"
    if user_params[:avatar].present?
      @user.avatar.attach(user_params[:avatar])
    end
    
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      flash.now[:danger] = 'Profile updated failed!'
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    d_user = User.find(params[:id])
    d_user_name = d_user.name
    d_user.destroy
    flash[:success] = "User - #{d_user_name} was deleted!"
    redirect_to users_url, status: :see_other
  end

  def following
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  def followers
    @title = 'Followers'
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,:avatar,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
