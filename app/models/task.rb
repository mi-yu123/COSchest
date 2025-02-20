class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
end
