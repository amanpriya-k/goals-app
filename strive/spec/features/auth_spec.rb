# spec/features/auth_spec.rb

require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  background :each do
    visit new_user_path
  end
  
  scenario 'has a new user page' do
    expect(page).to have_content("Sign up")
  end

  feature 'signing up a user' do
    scenario 'shows username on the homepage after signup' do
      fill_in "username", with: "test"
      fill_in "password", with: "123456"
      click_button "Sign up!"
      expect(page).to have_content("test")
    end
  end
  
end

feature 'logging in' do
  scenario 'shows username on the homepage after login' do
    visit new_session_path
    User.create(username: "test", password: "123456")
    fill_in "username", with: "test"
    fill_in "password", with: "123456"
    click_button "Log in!"
    expect(page).to have_content("test")
  end
end

feature 'logging out' do
  scenario 'begins with a logged out state' do
    user = User.create(username: "test", password: "123456")
    visit user_path
    expect(current_path).to be(new_session_url)
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    visit new_session_path
    User.create(username: "test", password: "123456")
    fill_in "username", with: "test"
    fill_in "password", with: "123456"
    click_button "Log in!"
    click_button "Log out!"
    expect(page).not_to have_content("test")
  end

end