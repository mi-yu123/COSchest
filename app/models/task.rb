class Task < ApplicationRecord
  belongs_to :user

  default_scope { order(created_at: :desc) }
  scope :user_tasks, ->(user) { where(user: user) }

  validates :title, presence: true, length: { maximum: 50, message: "は50文字以内で入力してください" }
  validates :description, length: { maximum: 200, message: "は200文字以内で入力してください" }

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
end
