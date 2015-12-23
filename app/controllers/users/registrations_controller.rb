class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    generated_password = Devise.friendly_token.first(8)

    if user = User.find_by_email(sign_up_params[:email])
      set_flash_message :notice, :already_registered if is_flashing_format?
      redirect_to new_user_registration_path
    else
      user = User.create! email: sign_up_params[:email],
                          password: generated_password,
                          password_confirmation: generated_password

      if user.persisted?
        if user.active_for_authentication?
          RegistrationMailer.welcome(user, generated_password).deliver_later
          set_flash_message :notice, :new_user_password_sent if is_flashing_format?
          # sign_up(resource_name, user)
          # respond_with user, location: after_inactive_sign_up_path_for(user)
          redirect_to carts_path
        else
          set_flash_message :notice, :"signed_up_but_#{user.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with user, location: after_inactive_sign_up_path_for(user)
        end
      else
        clean_up_passwords user
        set_minimum_password_length
        respond_with user
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected
  #
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :password
  #   devise_parameter_sanitizer.for(:sign_up) << :password_confirmation
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
