class Blog < ApplicationRecord

  belongs_to :user
  has_many :comments, dependent: :destroy

  has_many :likes, as: :likable, dependent: :destroy

  mount_uploader :featured_image, BlogImageUploader

end
