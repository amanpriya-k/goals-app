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
      
      it "flashes an error" do
        post :create, params: {user: {username: "blah", password: "short"}}
        expect(flash[:errors]).to eq(["Invalid username or password"])
      end
    end
  end
  
  describe "GET #show" do
    it "shows correct user" do
      user = FactoryBot.create(:user)
      get :show, params: {id: user.id}
      expect(assigns(:user)).to eq(user)
    end
  end
  
  describe "GET#edit" do
    it "find correct user by id" do
      user = FactoryBot.create(:user)
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
    
    it "renders the edit form" do
      user = FactoryBot.create(:user)
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end
  # 
  describe "PATCH#update" do
    context "with valid params" do
      it "saves new information to database" do
        user = FactoryBot.create(:user)
        patch :update, params: { id: user.id, user: { username: 'new_username' } }
        user = User.find(user.id)
        expect(user.username).to eq('new_username')
      end
  
      it "redirects to user#show" do
        user = FactoryBot.create(:user)
        patch :update, params: { id: user.id, user: { username: 'new_username' } }
        expect(response).to redirect_to(user_path(user))
      end
    end
  
    context "with invalid params" do
      it "doesn't update database" do
        other_user = FactoryBot.create(:user, username: 'dup_username')
        user = FactoryBot.create(:user)
        old_username = user.username
        patch :update, params: { id: user.id, user: { username: 'dup_username' } }
        expect(user.username).to eq(old_username)
      end
  
      it "rerender user#edit" do
        other_user = FactoryBot.create(:user, username: 'dup_username')
        user = FactoryBot.create(:user)
        patch :update, params: { id: user.id, user: { username: 'dup_username' } }
        expect(response).to render_template :edit
      end
  
      it "flashes an error" do
        other_user = FactoryBot.create(:user, username: 'dup_username')
        user = FactoryBot.create(:user)
        patch :update, params: { id: user.id, user: { username: 'dup_username' } }
        expect(flash[:errors]).to eq(["Invalid username or password"])
      end
    end
  
  end
  
  describe "DELETE#destroy" do
    it "locates correct user" do
      user = FactoryBot.create(:user)
      delete :destroy, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
    
    it "deletes from database" do
      user = FactoryBot.create(:user)
      delete :destroy, params: { id: user.id }
      expect(User.exists?(username: user.username)).to be(false)
    end
    
    it "renders user#new" do
      user = FactoryBot.create(:user)
      delete :destroy, params: { id: user.id }
      expect(response).to render_template :new
    end
  end
  
# end for class   
end