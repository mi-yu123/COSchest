class Article < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_one_attached :featured_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
    attachable.variant :medium, resize_to_limit: [ 300, 300 ]
    attachable.variant :large, resize_to_limit: [ 800, 800 ]
  end
  has_many :bookmarks, dependent: :destroy

  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  validates :title, presence: true, length: { maximum: 100, message: "は100文字以内で入力してください" }

  validate :content_presence
  validate :content_length_within_limit

  def tag_list
    tags.map(&:name).join(',')
  end

  def tag_list=(names)
    self.tags = names.split(',').map(&:strip).uniq.map do |name|
      next if name.blank?
      Tag.find_or_create_by!(name: name)
    end.compact
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title user_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[tags user]
  end

  private

  def content_presence
    if content.blank? || content.to_plain_text.blank?
      errors.add(:content, "を入力してください")
    end
  end

  def content_length_within_limit
    if content.present? && content.to_plain_text.length > 10_000
      errors.add(:content, "は10000文字以内で入力してください")
    end
  end
end
