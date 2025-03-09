class Costume < ApplicationRecord
  belongs_to :user
  has_many :packing_lists, as: :itemable, dependent: :destroy
  has_one_attached :image

  enum status: { completed: 0, incomplete: 1 }

  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    unless image.byte_size <= 5.megabyte
      errors.add(:image, "は5MB以下にしてください")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "はjpegまたはpng形式にしてください")
    end
  end
end
