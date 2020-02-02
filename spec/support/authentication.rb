module AuthenticationForFeatureRequest
  def login user, password = 'login'
    user.update_attributes password: password

    page.driver.post user_sessions_url, {email: user.email, password: password}
    visit root_url
  end
end
