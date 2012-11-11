require 'spec_helper'

describe "Users::Sessions" do
  subject { page }

  describe 'Login page' do
    before { visit new_user_session_path }

    it { should have_selector( 'input#input-username' ) }
    it { should have_selector( 'input#input-password' ) }
    it { should have_selector( 'input[name=commit]' ) }

  end
  describe 'Login' do
    before { visit new_user_session_path }

    describe "with invalid information" do

      before { click_button "Login" }


      it { should have_selector('h1', text: 'Login') }
      it { should have_selector('div.alert-danger', text: 'Invalid email or password') }
      describe "after visiting another page" do
        before { visit new_user_session_path }
        it { should_not have_selector('div.alert-danger') }
      end
    end
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit new_user_session_path
        fill_in("input-username", :with => user.email)
        fill_in("input-password", :with => "please")
        click_button("Login")
      end

      describe 'it should have good links' do

        it { should have_link('Logout', href: destroy_user_session_path ) }
        it { should have_link('Edit Account', href: edit_user_path(user.id) ) }
        it { should have_link('My Profile', href: user_path(user.id) ) }
      end
      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_selector('input#input-username') }
        it { should have_selector('div.alert-info', text: 'Signed out successfully.') }
        it { should_not have_link('Logout', href: destroy_user_session_path ) }
        it { should_not have_link('Edit Account', href: edit_user_path(user.id) ) }
      end
    end
  end
end
