require 'spec_helper'

describe Users::SessionsController do

  describe 'Login' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_session_path
    end
    it { should have_link('User Settings') }
  end
end
