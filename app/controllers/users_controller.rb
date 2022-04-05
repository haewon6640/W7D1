class UsersController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  def new
    render :new
  end

  def create
    @user = User.new(user_name: params[:user][:username])
    @user.password=params[:user][:password]
    if @user.save!
      login(@user)
      redirect_to cats_url
    else
      render :new
    end
  end
end
