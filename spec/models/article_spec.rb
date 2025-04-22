require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'バリデーション' do
    subject { build(:article) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_rich_text(:content) }
    it { is_expected.to have_one_attached(:featured_image) }
    it { is_expected.to have_many(:bookmarks).dependent(:destroy) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(100).with_message('は100文字以内で入力してください') }  
  end

  describe 'contentのバリデーション' do
    let(:article) { build(:article) }

    context 'contentが空の場合' do
      before { article.content = nil }

      it 'バリデーションエラーになる' do
        article.content = ActionText::Content.new("")
        article.valid?
        expect(article.errors[:content]).to include("を入力してください")
      end

      context 'contentが10000文字を超える場合' do
        before { article.content = 'a' * 10001 }

        it 'バリデーションエラーになる' do
          article.valid?
          expect(article.errors[:content]).to include("は10000文字以内で入力してください")
        end
      end

      context 'contentが10000文字以内の場合' do
        before { article.content = 'a' * 10000 }

        it 'バリデーションエラーにならない' do
          expect(article).to be_valid
        end
      end
    end
  end

  describe '添付画像のバリデーション' do
    let(:article) { create(:article, :with_featured_image) }

    it '画像が正常に添付される' do
      expect(article.featured_image).to be_attached
    end

    it 'バリアントが正常に作成される' do
      expect(article.featured_image.variant(:thumb).processed).to be_present
      expect(article.featured_image.variant(:medium).processed).to be_present
      expect(article.featured_image.variant(:large).processed).to be_present
    end
  end

  describe 'ransackable_attributes' do
    it 'ransack によって使用可能な属性を返す' do
      expect(Article.ransackable_attributes).to match_array(%w[title user_id])
    end
  end

  describe 'ransackable_associations' do
    it '空の配列を返すこと' do
      expect(Article.ransackable_associations).to be_empty
    end
  end
end
