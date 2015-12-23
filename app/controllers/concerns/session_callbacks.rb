module SessionCallbacks

  def after_sign_in_path_for(resource)
    sess.update_attributes user_id: current_user.id
    session['props'] = {}
    root_path(resource)
  end

  def sess
    env["rack.session.record"]
  end

  def force_session
    if !session.loaded?
      session['init'] = true
      sess.save
    end
  end

end
