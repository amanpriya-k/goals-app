require 'rails_helper'

RSpec.describe User, type: :model do
  describe "user validations" do
    it {should validate_presence_of(:username)}
    it {should validate_presence_of(:password_digest)}
    it {should validate_presence_of(:session_token)}
    it {should validate_length_of(:password).is_at_least(6).with_message("Password must be at least 6 characters.")}
  end
  
  describe "user#ensure_session_token" do
    it "assigns session token if session token is nil" do
      user = FactoryBot.build(:user, session_token: nil)
      user.ensure_session_token
      expect(user.session_token).not_to be_nil
    end
    
    it "doesn't change session token if not nil" do
      user = FactoryBot.create(:user)
      user.ensure_session_token
      expect(user.session_token).to eq("123456")
    end
  end
  
  describe "User#password=()" do
    it "creates an instance variable for password" do
      user = FactoryBot.create(:user)
      expect(user.password).to eq("abcdef")
    end
    it "encrypts password and sets password_digest" do
      user = FactoryBot.create(:user)
      expect(user.password_digest).not_to be_nil
      expect(user.password_digest).not_to eq("abcdef")
    end
  end
  
  describe "User::find_by_credentials" do
    it "locates a user by username and checks password" do
      user = FactoryBot.create(:user, password: 'password')
      username = user.username
      expect(User.find_by_credentials(username, 'password')).to eq(user)
    end
    it "returns nil if no matching user" do
      user = FactoryBot.create(:user, password: 'password')
      expect(User.find_by_credentials('notauser', 'password')).to be_nil
    end
    it "returns nil if wrong password" do
      user = FactoryBot.create(:user, password: 'password')
      username = user.username
      expect(User.find_by_credentials(username, 'wrongpassword')).to be_nil
    end
  end
  
  describe "User#reset_session_token" do
    it "changes the user session_token" do
      user = FactoryBot.create(:user)
      prev_session_token = user.session_token
      user.reset_session_token
      expect(user.session_token).not_to eq(prev_session_token)
    end
  end
  
end