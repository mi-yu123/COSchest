class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable,
omniauth_providers: [ :twitter2 ]

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = "#{auth.uid}-#{auth.provider}@example.com"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image = auth.info.image
    end
  end

  def remember_me
    true
  end

  def bookmark(article)
    bookmark_articles << article
  end

  def unbookmark(article)
    bookmark_articles.delete(article)
  end

  def bookmarked?(article)
    bookmark_articles.include?(article)
  end

  has_many :costumes, dependent: :destroy
  has_many :wigs, dependent: :destroy
  has_many :contact_lenses, class_name: 'ContactLens', dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :packing_lists, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_articles, through: :bookmarks, source: :article
  has_many :my_photos, dependent: :destroy
end
