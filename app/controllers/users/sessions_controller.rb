class Users::SessionsController < Devise::SessionsController
  layout :users_layout

  private
    def users_layout
      user_signed_in? ? 'application' : 'login'
    end
end
