Warden::Strategies.add(:my_token) do

  def valid?
    params['token']
  end

  def authenticate!
    u = User.find_by_id(1)
    u.nil? ? fail!("Could not log in") : success!(u)
  end
end

Warden::Manager.after_set_user do |user, auth, opts|
  auth.env["rack.session.options"][:renew] = false
end
