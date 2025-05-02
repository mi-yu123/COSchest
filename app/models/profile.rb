class Profile < ApplicationRecord
  belongs_to :user

  enum activity: { no_activity: 0, layer: 1, camera: 2 }

  has_one_attached :image
end
