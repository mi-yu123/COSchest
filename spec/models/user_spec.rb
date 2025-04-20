require 'rails_helper'
require 'ostruct'

RSpec.describe User, type: :model do
  describe 'アソシエーション' do
    it { should have_many(:costumes).dependent(:destroy) }
    it { should have_many(:wigs).dependent(:destroy) }
    it { should have_many(:contact_lenses).dependent(:destroy) }
    it { should have_many(:articles).dependent(:destroy) }
    it { should have_many(:tasks).dependent(:destroy) }
    it { should have_many(:packing_lists).dependent(:destroy) }
    it { should have_one(:profile).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmark_articles).through(:bookmarks) }
  end

  describe 'from_omniauth' do
    let(:auth) do
      OpenStruct.new(
        provider: 'twitter2',
        uid: '123456',
        info: OpenStruct.new(
          name: 'test_user',
          image: 'http://example.com/image.jpg',
        )
      )
    end

    it 'X認証情報からユーザーを作成する' do
      user = User.from_omniauth(auth)

      expect(user.provider).to eq('twitter2')
      expect(user.uid).to eq('123456')
      expect(user.name).to eq('test_user')
      expect(user.image).to eq('http://example.com/image.jpg')
      expect(user.email).to eq("123456-twitter2@example.com")
    end
  end

  describe 'ブックマーク機能' do
    let(:user) { create(:user) }
    let(:article) { create(:article) }

    before do
      user.bookmark(article)
    end

    it 'ブックマークができること' do
      expect(user.bookmark_articles).to include(article)
    end

    it 'ブックマークを解除できること' do
      user.unbookmark(article)
      expect(user.bookmark_articles).not_to include(article)
    end
  end
end
