class Article < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  validates :title, presence: true, length: { maximum: 100, message: "は100文字以内で入力してください" }
  validates :content, presence: true, length: { maximum: 10000, message: "は10000文字以内で入力してください" }
end
