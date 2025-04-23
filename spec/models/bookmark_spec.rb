require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:article) }
  end

  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:article) { create(:article) }
    let(:bookmark) { build(:bookmark, user: user, article: article) }

    context 'ユニークであることの検証' do
      it '同じユーザーが同じ記事をブックマークすることはできないこと' do
        duplicate_bookmark = create(:bookmark, user: user, article: article)
        expect(bookmark).not_to be_valid
      end

      it '異なるユーザーは同じ記事をブックマークできること' do
        other_user = create(:user)
        other_bookmark = build(:bookmark, user: other_user, article: article)
        expect(other_bookmark).to be_valid
      end

      it '同じユーザーは異なる記事をブックマークできること' do
        other_article = create(:article)
        other_bookmark = build(:bookmark, user: user, article: other_article)
        expect(other_bookmark).to be_valid
      end
    end
  end

  describe 'データベースの検証' do
    it 'user_idとarticle_idの組み合わせがユニークであること' do
      bookmark = create(:bookmark)
      expect {
        create(:bookmark, user: bookmark.user, article: bookmark.article)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '基本的な機能' do
    let!(:bookmark) { create(:bookmark) }

    it 'ブックマークが正しく作成されること' do
      expect(bookmark).to be_valid
    end

    it 'ブックマークが正しく削除されること' do
      expect { bookmark.destroy }.to change(Bookmark, :count).by(-1)
    end
  end
end
