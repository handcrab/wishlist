class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    # request.env["omniauth.auth"] = All information retrieved from Vk
    @user = User.from_omniauth request.env["omniauth.auth"] #, current_user

    if @user.persisted?
      set_flash_message(:notice, :success, kind: "Vkontakte") if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.vkontakte_data"] = @user.attributes
      # request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end
end
