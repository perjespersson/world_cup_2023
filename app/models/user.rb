class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :bets

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user.nil?
      User.create(
                  email: auth.info.email,
                  password: Devise.friendly_token[0, 20],
                  name: auth.info.name,
                  avatar_url: auth.info.image,
                  provider: auth.provider,
                  uid: auth.uid
                )
    elsif user.uid.nil? || user.provider.nil? # User has not signed up through google
      return nil
    else
      return user
    end
  end
end
