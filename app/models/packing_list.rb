class PackingList < ApplicationRecord
  belongs_to :user
  belongs_to :itemable, polymorphic: true, optional: true

  validates :item, presence: true
end
