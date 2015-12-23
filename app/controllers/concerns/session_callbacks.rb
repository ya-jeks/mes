module SessionCallbacks

  def after_sign_in_path_for(resource)
    session_record.update_attributes user_id: current_user.id
    root_path(resource)
  end

  def session_record
    env["rack.session.record"]
  end

  def force_session
    if !session.loaded?
      session['init'] = true
      session_record.save
    end
  end

end
