Warden::Manager.after_set_user do |user, auth, opts|
  auth.env["rack.session.options"][:renew] = false
end