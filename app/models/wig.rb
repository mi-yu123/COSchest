class Wig < ApplicationRecord
  belongs_to :user
  has_many :packing_lists, as: :itemable, dependent: :destroy

  mount_uploader :image, ImageUploader

  enum status: { completed: 0, incomplete: 1 }

  private

  def image_size_validation
    if image.present? && image.size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
  end
end
