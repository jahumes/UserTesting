require 'spec_helper'

describe Contact do
  it "has a valid factory" do
    FactoryGirl.create(:contact).should be_valid
  end
  it "is invalid without a first_name" do
    FactoryGirl.build(:contact, first_name: nil).should_not be_valid
  end
  it "is invalid without a last_name" do
    FactoryGirl.build(:contact, last_name: nil).should_not be_valid
  end
  it "returns a contact's full name as a string" do
    contact = FactoryGirl.create(:contact, first_name: "John", last_name: "Doe")
    contact.name.should == "John Doe"
  end
  describe "filter last name by letter" do
    before :each do
      @smith = FactoryGirl.create(:contact, last_name: "Smith")
      @jones = FactoryGirl.create(:contact, last_name: "Jones")
      @johnson = FactoryGirl.create(:contact, last_name: "Johnson")
    end
    context "matching letters" do
      it "returns a sorted array of results that match" do
        Contact.by_letter("J").should == [@johnson, @jones]
      end
    end
    context "non-matching letters" do
      it "does not return contacts that don't start with the provided letter" do
        Contact.by_letter("J").should_not include @smith
      end
    end
  end
  describe "search, sort, & paginate contacts" do
    before :each do
      @smith = FactoryGirl.create(:contact, first_name: "John", last_name: "Smith", email: "crazy@example.com")
      @rotten = FactoryGirl.create(:contact, first_name: "Jack", last_name: "Rotten", email: "falksd@example.com")
      @jones = FactoryGirl.create(:contact, first_name: "Sanders", last_name: "Jones", email: "sanders@example.com")
      @johnson = FactoryGirl.create(:contact, first_name: "Ryan", last_name: "Johnson", email: "ryan@example.com")
      @helios = FactoryGirl.create(:contact, first_name: "Kyle", last_name: "Helios", email: "jackman@example.com")
      @top = FactoryGirl.create(:contact, first_name: "Ken", last_name: "Top", email: "johner@example.com")
      @fanders = FactoryGirl.create(:contact, first_name: "K'Dos", last_name: "Fanders", email: "upqle@example.com")
      @howard = FactoryGirl.create(:contact, first_name: "Iliam", last_name: "Howard", email: "riapsdf@example.com")
    end
    context "matching" do
      context "search" do
        it "returns a sorted array of results that match query on last name" do
          Contact.search("j").should include @smith, @rotten
        end
        it "returns a sorted array of results that match query on first name" do
          Contact.search("j").should include @jones, @johnson
        end
        it "returns a sorted array of results that match query on email" do
          Contact.search("j").should include @helios, @top
        end
      end
      context "sort" do
        it "returns an array of results sorted by last name" do
          Contact.order("last_name asc").first.should == @fanders
        end
        it "returns an array of results sorted by email" do
          Contact.order("email asc").first.should == @smith
        end
      end
      context "paginate" do
        it "returns an array of 5 items" do
          Contact.page(1).per(5).count.should == 5
        end
        it "returns the second page of results" do
          Contact.page(2).per(5).first.should == @top
        end
      end
    end
    context "non-matching" do
      context "search" do
        it "does not return results on last name, first name, or email that don't begin with the query" do
          Contact.search("j").should_not include @fanders, @howard
        end
      end
      context "sort" do
        it "does not return an array sorted in the wrong direction by last name" do
          Contact.order("last_name asc").first.should_not == @top
        end
        it "does not return an array sorted in the wrong direction by email" do
          Contact.order("email asc").first.should_not == @fanders
        end
      end
      context "paginate" do

      end
    end





  end

end
