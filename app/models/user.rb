class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter2]

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = "#{auth.uid}-#{auth.provider}@example.com"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image = auth.info.image
    end
  end

  has_many :costumes, dependent: :destroy
  has_many :wigs, dependent: :destroy
  has_many :contact_lenses, class_name: 'ContactLens', dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :packing_lists, dependent: :destroy
end
