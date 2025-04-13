class Wig < ApplicationRecord
  belongs_to :user
  has_many :packing_lists, as: :itemable, dependent: :destroy
  has_one_attached :image

  enum status: { completed: 0, incomplete: 1 }

  validate :image_content_type
  validate :image_size

  def self.ransackable_attributes(auth_object = nil)
    %w[character_name status]
  end

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
    
    image.variant(resize_to_limit: [800, 800]).processed
  end
end
