class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter]
  has_many :costumes
  has_many :wigs
  has_many :contactlenses
  has_many :articles
end
