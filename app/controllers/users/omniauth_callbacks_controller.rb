class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    logger.debug("calling facebook callback")
    logger.debug(request.env.inspect)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      @user.save if @user.uid_changed?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      user = User.new_with_session(params, session)
      user.assign_attributes(type: 'Both')
      if user.save
        redirect_to root_url
      else
        redirect_to new_user_registration_url
      end
    end
  end

  def failure
    redirect_to root_path
  end
end