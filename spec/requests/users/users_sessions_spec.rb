require 'spec_helper'

describe "Users::Sessions" do
  subject { page }

  describe 'Login page' do
    before { visit new_user_session_path }

    it { should have_selector( 'input#user_email' ) }
    it { should have_selector( 'input#user_password' ) }
    it { should have_selector( 'input[name=commit]' ) }

  end
  describe 'Login' do
    before { visit new_user_session_path }

    describe "with invalid information" do

      before { click_button "Login" }


      it { should have_selector('title', text: 'Login') }
      it { should have_selector('div.nFailure', text: 'Invalid email or password') }
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.nFailure') }
      end
    end
    describe "width valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit new_user_session_path
        fill_in("user_email", :with => user.email)
        fill_in("user_password", :with => "please")
        click_button("Login")
      end

      describe 'it should have good links' do

        it { should have_link('Logout', href: destroy_user_session_path ) }
        it { should have_link('User Settings', href: edit_user_registration_path ) }
        it { should have_link('Home', href: user_session_path ) }
      end
      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_selector('input#user_email') }
        it { should have_selector('div.nSuccess', text: 'Signed out successfully.') }
        it { should_not have_link('Logout', href: destroy_user_session_path ) }
        it { should_not have_link('User Settings', href: edit_user_registration_path ) }
      end
    end
  end
end
