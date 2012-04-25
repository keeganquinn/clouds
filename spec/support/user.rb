def setup_user(username = 'test', email = 'test@test.com', password = 'test123')
  u = User.new(username: username, email: email, password: password)
  u.confirmed_at = Time.now

  u.save
  return u
end

def login_user
  before do
    @user = setup_user
    post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end
end
