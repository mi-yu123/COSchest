class PackingList < ApplicationRecord
  belongs_to :user
  belongs_to :itemable, polymorphic: true, optional: true

  validates :item, presence: true, unless: :itemable_present?
  validates :item, length: { maximum: 50, message: 'は50文字以内で入力してください' }, if: :item?

  private

  def itemable_present?
    itemable.present? && itemable_id.present?
  end
end
