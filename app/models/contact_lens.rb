class ContactLens < ApplicationRecord
  self.table_name = 'contact_lenses'
  belongs_to :user
  before_save :set_expiration_date_to_beginning_of_month
  has_many :packing_lists, as: :itemable, dependent: :destroy

  has_one_attached :image

  validate :image_content_type
  validate :image_size

    def image_content_type
      if image.attached? && !image.content_type.in?(%w[image/jpeg image/png])
        errors.add(:image, 'ファイルの形式はJPEGまたはPNGである必要があります。')
      end
    end

  def image_size
    if image.attached? && image.byte_size > 5.megabytes
      errors.add(:image, 'ファイルサイズは5MB以下である必要があります。')
    end
  end

  def resize_image
    return unless image.attached?
    
    image.variant(resize_to_limit: [800, 800]).processed
  end

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
end
