class PackingList < ApplicationRecord
  belongs_to :user
  belongs_to :itemable, polymorphic: true, optional: true

  validate :item_or_itemable_present
  validates :item, length: { maximum: 50, message: 'は50文字以内で入力してください' }, if: :item?

  private

  def item_or_itemable_present
    if item.blank? && itemable_id.blank?
      errors.add(:base, 'アイテム名を入力、または関連アイテムを選択してください')
    end
  end
end
