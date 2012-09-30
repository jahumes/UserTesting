class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'users'

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new

  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

end
