class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates_confirmation_of :password
  
  validates_presence_of :password_confirmation, :if => :password_changed?
  
  validates_presence_of :full_name, :email, :roles
  
  has_and_belongs_to_many :roles
  
  def password_changed?
    !@new_password.blank?
  end
end
