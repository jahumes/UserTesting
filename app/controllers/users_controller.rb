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
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create

    if !params[:user][:role_ids].empty?
      @roles = params[:user].delete(:role_ids).map { |s| s.to_i }
    else
      params[:user].delete(:role_ids)
    end

    @user = User.new(params[:user])
    if @user.save
      if @roles
        @roles.each do |role|
          @role = Role.find_by_id(role)
          if !@role.nil?
            @user.add_role @role.name
          end

        end
      end
      flash[:success] = "User Successfully Created!"
      redirect_to @user
    else
      flash[:error] = "Failed to Create User!"
      render 'new'
    end
  end

end
