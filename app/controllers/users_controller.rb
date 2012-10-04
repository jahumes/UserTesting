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
    @roles = Role.all
  end

  def create

    @roles = params[:user].delete(:roles).split(",").map { |s| s.to_i }

    @user = User.new(params[:user])
    if @user.save
      if @roles
        @roles.each do |role|
          @role = Role.find_by_id(role)
          @user.add_role @role.name
        end
      end
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

end
