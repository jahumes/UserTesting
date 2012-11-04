class UsersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  layout 'users'

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    puts per_page
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
