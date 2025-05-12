require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }

  describe '記事一覧表示' do
    before do
      create_list(:article, 3, user: user)
      visit articles_path
    end

    it '記事一覧が表示される' do
      expect(page).to have_content('記事一覧')
    end
  end

  describe '記事の詳細表示' do
    before { visit article_path(article) }

    it '記事の詳細が表示される' do
      expect(page).to have_content(article.title)
      within('.trix-content') do
        expect(page).to have_content(article.content.body.to_plain_text)
      end
    end
  end

  describe '記事の新規作成' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        visit new_article_path
        expect(current_path).to eq new_user_session_path
      end
    end

    context 'ログインしている場合' do
      before do
        sign_in user
        visit new_article_path
      end

      it '新規作成できる' do
        fill_in 'タイトル', with: 'Test Article'
        find('trix-editor').click.set('This is a test article.')
        click_button '投稿する'
        expect(page).to have_content('Test Article')
      end
    end
  end

  describe '記事の編集' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit edit_article_path(article)
      end

      it '編集できる' do
        fill_in 'タイトル', with: 'Updated Article'
        find('trix-editor').click.set('This is an updated article.')
        click_button '更新する'
        expect(page).to have_content('Updated Article')
      end
    end
  end
end
