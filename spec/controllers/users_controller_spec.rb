require 'spec_helper'

describe UsersController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "Get Pages" do
    render_views
    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
        response.should render_template("new")
      end

      it "should have the right title" do
        get :new
        response.body.should have_selector(:title,'Add New User')
      end
    end

    describe "GET 'show'" do
      it "should be successful" do
        get :show, :id => @user.id
        response.should be_success
      end

      it "should find the right user" do
        get :show, :id => @user.id
        assigns(:user).should == @user
      end

    end

    describe "GET 'edit'" do
      it "should be successful" do
        get :edit, :id => @user.id
        response.should be_success
      end

      it "should find the right user" do
        get :edit, :id => @user.id
        response.should render_template("edit")
      end

    end
    describe "GET 'index'" do
      it "should be successful" do
        get :index
        response.should be_success
        response.body.should render_template("index")
      end

      it "should find the right user" do
        get :index, :id => @user.id

      end

    end
  end



  describe "CREATE new user" do
    before (:each) do
      @new_user_attr = FactoryGirl.attributes_for(:user)
    end
    describe "with valid information" do
      it "should redirect to new user with success message" do
        @new_user_attr[:email] = Faker::Internet.email
        mock_user = mock_model User, :attributes => @new_user_attr, :save => true
        User.stub(:new) { mock_user }
        post :create, :user => @new_user_attr
        flash[:success].should_not be_nil
        flash[:success].should == "User Successfully Created!"
        response.should redirect_to(user_path(mock_user))
      end
    end
    describe "with invalid information" do
      it "should have an error flash and render new again" do
        @new_user_attr[:email] = ''
        post :create, :user => @new_user_attr
        flash[:error].should_not be_nil
        flash[:error].should == "Failed to Create User!"
        response.should render_template :new
      end
    end
  end

  describe "Edit User" do
    before(:each) do
      @new_user = FactoryGirl.create(:user)
    end
  end

end
