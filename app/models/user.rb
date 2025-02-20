class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter]
  has_many :costumes, dependent: :destroy
  has_many :wigs, dependent: :destroy
  has_many :contact_lenses, class_name: 'ContactLens', dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :tasks, dependent: :destroy
end
