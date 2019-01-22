class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # File Uploader
  mount_uploader :profile_image, UserProfileImageUploader

  has_many :authentications, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes


  validates :first_name, :last_name, :email, presence: true
  validates :first_name, :last_name, :format => {:with => /\A[A-Za-z0-9]+[-_]?[A-Za-z0-9]*\z/ , :message => "should not contain special characters except '_ -'"},:length =>  {within: 1..150}, if: proc {(self.first_name.present? && self.first_name_changed?) || ((self.last_name.present? && self.last_name_changed?))}

  def reset_authentication_token!
    update_column(:authentication_token, Devise.friendly_token)
  end

end
