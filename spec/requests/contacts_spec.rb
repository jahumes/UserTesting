require 'spec_helper'

describe "Contacts" do
  subject { page }
  describe "GET /contacts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit ( contacts_path )
      page.should have_selector('h1',:content => 'New contact')
    end
  end
  describe "New Contact" do
    before { visit new_contact_path }
    it "works! (now write some real specs)" do
      page.should have_selector('h1',:content => 'New contact')
    end
  end
end
