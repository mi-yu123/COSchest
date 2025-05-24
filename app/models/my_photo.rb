class MyPhoto < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :image, presence: true
  validates :title, length: { maximum: 100 }
  validates :memo, length: { maximum: 1000 }

  before_create :set_posted_at

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

    image.variant(resize_to_limit: [ 800, 800 ]).processed
  end

  private

  def set_posted_at
    self.posted_at = Time.current
  end
end
