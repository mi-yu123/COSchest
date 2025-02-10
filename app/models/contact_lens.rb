class ContactLens < ApplicationRecord
  self.table_name = 'contact_lenses'

  mount_uploader :image, ImageUploader

  private

  def image_size_validation
    if image.present? && image.size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
  end
end
