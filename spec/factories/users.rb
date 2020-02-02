FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    icon_img_url { 'https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png' }
    sequence(:enc_access_token) { |n| "enc_access_token_#{n}" }
    sequence(:enc_access_token_secret) { |n| "enc_access_token_secret_#{n}" }
    sequence(:salt) { |n| "salt_#{n}" }
    sequence(:secret_salt) { |n| "salt_secret_#{n}" }
  end

  factory :test_user, class: User do
    name { 'test_name' }
    email { 'another_user@example.com' }
    password { 'password' }
    secret_salt { 'test' }
    enc_access_token { 'test' }
    enc_access_token_secret { 'test' }
  end

end
