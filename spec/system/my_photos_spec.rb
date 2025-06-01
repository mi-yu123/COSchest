require 'rails_helper'

RSpec.describe "My Photos", type: :system do
  let(:user) { create(:user) }
  let(:image_path) {  Rails.root.join('spec/fixtures/test.jpg')  }

  before do
    driven_by(:rack_test)
    sign_in user
  end

  describe 'マイフォト一覧表示' do
    let!(:my_photo) { create(:my_photo, :with_jpeg_image, user: user) }

    it 'マイフォト一覧が表示される' do
      visit my_photos_path
      expect(page).to have_content my_photo.title
    end
  end

  describe '新規投稿' do
    before { visit new_my_photo_path }

    context '入力内容が正しい場合' do
      it '新規投稿に成功する' do
        attach_file 'my_photo[image]', Rails.root.join('spec/fixtures/files/test.jpeg')
        fill_in 'my_photo[title]', with: 'Test Photo'
        fill_in 'my_photo[memo]', with: 'This is a test photo.'

        expect {
          click_button '登録する'
        }.to change(MyPhoto, :count).by(1)

        expect(page).to have_content 'マイフォトが登録されました'
      end
    end

    context '入力内容が不正な場合' do
      it '新規投稿に失敗する' do
        fill_in 'my_photo[title]', with: 'Test Photo'
        fill_in 'my_photo[memo]', with: 'This is a test photo.'
        
        expect {
          click_button '登録する'
        }.not_to change(MyPhoto, :count)
        
        expect(page).to have_content 'この項目を入力してください'
      end
    end
  end

  describe '編集' do
    let!(:my_photo) { create(:my_photo, :with_jpeg_image, user: user) }

    before { visit edit_my_photo_path(my_photo) }

    context '入力内容が正しい場合' do
      it '編集に成功する' do
        fill_in 'my_photo[title]', with: 'Updated Photo'
        fill_in 'my_photo[memo]', with: 'Updated memo.'
        click_button '更新する'

        expect(page).to have_content 'マイフォトが更新されました'
      end
    end

    context '入力内容が不正な場合' do
      it '編集に失敗する' do
        fill_in 'my_photo[title]', with: 'a' * 101
        click_button '更新する'

        expect(page).to have_content '更新に失敗しました'
      end
    end
  end

  describe '権限' do
    let(:other_user) { create(:user) }
    let!(:other_my_photo) { create(:my_photo, :with_jpeg_image, user: other_user) }

    it '他のユーザーのマイフォトが表示されない' do
      visit my_photos_path(other_my_photo)
      expect(page).not_to have_content other_my_photo.title
    end

    it '他のユーザーのマイフォト編集ページにアクセスできない' do
      visit edit_my_photo_path(other_my_photo)
      expect(page).to have_content "権限がありません"
    end
  end
end
