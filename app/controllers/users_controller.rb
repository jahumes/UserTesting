class UsersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(per_page)
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

  def update
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.js { render :text => {} }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.js { render :text => {} }
    end
  end

  def create

    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "User Successfully Created!"
      redirect_to @user
    else
      flash[:error] = "Failed to Create User!"
      render 'new'
    end
  end

  private
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
    end
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    def per_page
      [5,10,20,50,100].include?(params[:per_page].to_f) ? params[:per_page] : 5
    end
end
