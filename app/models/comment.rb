class Comment < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :blog, optional: true
  belongs_to :parent,  class_name: "Comment", optional: true

  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :likes, as: :likable

end
