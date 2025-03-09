class ContactLens < ApplicationRecord
  self.table_name = 'contact_lenses'
  belongs_to :user
  before_save :set_expiration_date_to_beginning_of_month
  has_many :packing_lists, as: :itemable, dependent: :destroy

  has_one_attached :image

  validate :acceptable_image

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
