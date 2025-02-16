class ContactLens < ApplicationRecord
  self.table_name = 'contact_lenses'
  belongs_to :user
  before_save :set_expiration_date_to_beginning_of_month

  mount_uploader :image, ImageUploader

  private

  def set_expiration_date_to_beginning_of_month
  return unless expiration_date_before_type_cast.present?
    
    if expiration_date_before_type_cast.is_a?(String)
      year, month = expiration_date_before_type_cast.split('-').map(&:to_i)
      self.expiration_date = Date.new(year, month, 1)
    end
  rescue Date::Error
    errors.add(:expiration_date, "は有効な日付ではありません")
  end

  def image_size_validation
    if image.present? && image.size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
  end
end
