class PackingList < ApplicationRecord
  belongs_to :user
  belongs_to :itemable, polymorphic: true, optional: true

  validates :item, presence: true, unless: :itemable_present?

  private

  def itemable_present?
    itemable.present? && itemable_id.present?
  end
end
