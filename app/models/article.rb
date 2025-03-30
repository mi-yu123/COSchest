class Article < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_one_attached :featured_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :medium, resize_to_limit: [300, 300]
    attachable.variant :large, resize_to_limit: [800, 800]
  end

  validates :title, presence: true, length: { maximum: 100, message: "は100文字以内で入力してください" }
  validates :content, presence: true, length: { maximum: 10000, message: "は10000文字以内で入力してください" }
end
