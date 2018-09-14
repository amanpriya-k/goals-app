FactoryBot.define do
  factory :user do
    username { Faker::PrincessBride.character }
    password { 'abcdef' }
    session_token { '123456' }
    
    # factory :user_no_session_token do
    #   session_token nil
    # end
    
  end
end