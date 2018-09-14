require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "render the new user template" do
      get :new
      expect(response).to render_template(:new)
    end
  end
  
  describe "POST #create" do
    context "with valid params" do
      it "makes a new user" do
        prev_length = User.all.length
        post :create, params: {user: {username: "blah", password: "password"}}
        expect(User.all.length).to eq(prev_length+1)
        expect(User.exists?(username: "blah")).to be(true)
      end
      
      it "logs the user in" do
      post :create, params: {user: {username: "blah", password: "password"}}
      user = User.find_by(username: "blah")
      expect(session[:session_token]).to eq(user.session_token)
      end
      
      it "redirects to show page" do
        post :create, params: {user: {username: "blah", password: "password"}}
        user = User.find_by(username: "blah")
        # expect(user.id).not_to be_nil
        expect(response).to redirect_to(user_path(user))
      end
    end
    
    context "with invalid params" do
      it "rerenders the new user template" do
        post :create, params: {user: {username: "blah", password: "short"}}
        expect(response).to render_template(:new)
      end
      
      it "throw error" do
        post :create, params: {user: {username: "blah", password: "short"}}
        expect(flash[:errors]).to be_present
      end
    end
  end
end