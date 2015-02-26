class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def display_name
    return get_name_from_mail if name.blank?
    name
  end
     
  private
  def get_name_from_mail
    email.match(/(.*?)@.*/)[1]
  end
end
