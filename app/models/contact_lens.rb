class ContactLens < ApplicationRecord
  self.table_name = 'contact_lenses'
  belongs_to :user
  before_save :set_expiration_date_to_beginning_of_month
  has_many :packing_lists, as: :itemable, dependent: :destroy

  has_one_attached :image

  validate :image_content_type
  validate :image_size

  def self.ransackable_attributes(auth_object = nil)
    %w[name expiration_date]
  end

  scope :with_expiration_date, ->(date_str) {
    return none unless date_str.present? && date_str.match?(/\A\d{4}-\d{2}\z/)

    year, month = date_str.split('-').map(&:to_i)
    begin
      target_date = Date.new(year, month, 1)
      where(expiration_date: target_date)
    rescue Date::Error
      none
    end
  }

  # 使用期限1ヶ月前のカラコンを取得
  scope :expiring_soon, -> {
    where('expiration_date BETWEEN ? AND ?',
      Date.current.beginning_of_month,
      1.month.from_now.end_of_month)
  }

  def self.ransackable_associations(auth_object = nil)
    []
  end

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

    image.variant(resize_to_limit: [ 800, 800 ]).processed
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
