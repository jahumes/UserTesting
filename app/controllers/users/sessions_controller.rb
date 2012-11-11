class Users::SessionsController < Devise::SessionsController
  layout :users_layout

  def create
    super
    flash.keep(:notice)
  end

  private
    def users_layout
      user_signed_in? ? 'application' : 'login'
    end
end
