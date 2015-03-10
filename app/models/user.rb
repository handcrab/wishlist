class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:vkontakte]

  has_many :wishes, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "100x100>", thumb: "25x25>" }
    # default_url: "/images/:style/avatar-missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def display_name
    return get_name_from_email if name.blank?
    name
  end

  def self.from_omniauth auth #, signed_in_resource=nil
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      # user.provider = auth.provider
      # user.uid = auth.uid

      user.name = auth.info.name
      user.email = auth.info.email || "#{auth.info.nickname}@vk.messenger.com"
      user.avatar = URI.parse auth.info.image
      #"#{auth.info.first_name}@vk.messenger.com"
      # user.password = Devise.friendly_token[0,20]
    end
  end

  def password_required?
    (provider.blank? || !password.blank?) && super
  end
  def omniauth_user?
    provider.present?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  # non-empty form
  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.vkontakte_data"]
  #       # && session["devise.vkontakte_data"]["extra"]["raw_info"]
  #       # raise data
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end
  # def self.new_with_session params, session
  # if session['devise.user_attributes']
  #   new session['devise.user_attributes'], without_protection: true do |user|
  #     user.attributes = params
  #     user.valid?
  #   end
  # else
  #   super
  # end

  private
  def get_name_from_email
    email.match(/(.*?)@.*/)[1]
  end
end
