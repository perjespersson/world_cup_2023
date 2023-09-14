class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    if google_user.present?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect google_user, event: :authentication
    else
      flash[:alert] =
        t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email}"
      redirect_to new_user_session_path
    end
  end

  private

  def google_user
    @google_user ||= begin
      if user.nil?
        User.create(
                    email: auth.info.email,
                    password: Devise.friendly_token[0, 20],
                    name: auth.info.name,
                    avatar_url: auth.info.image,
                    provider: auth.provider,
                    uid: auth.uid
                  )
      elsif user.uid.nil? || user.provider.nil? # User has not signed up through google yet
        return nil
      else
        return user
      end
    end
  end

  def user
    @user ||= User.find_by(email: auth.info.email)
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
