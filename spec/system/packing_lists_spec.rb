require 'rails_helper'

RSpec.describe 'Packing Lists', type: :system do
  let(:user) { create(:user) }
  let!(:costume) { create(:costume, user: user) }
  let!(:wig) { create(:wig, user: user) }

  before do
    driven_by(:rack_test)
    sign_in user
  end

  describe '持ち物リストの新規作成' do
    context '正常に入力された場合' do
      it 'アイテム名の入力で登録ができる' do
        visit new_packing_list_path

        fill_in 'アイテム名', with: 'テストアイテム'
        click_button '登録する'

        expect(page).to have_content '登録しました'
        expect(page).to have_content 'テストアイテム'
      end

      it '関連アイテムの選択で作成ができる' do
        visit new_packing_list_path

        page.driver.submit :post, packing_lists_path, {
          packing_list: {
            itemable_type: 'Costume',
            itemable_id: costume.id
          }
        }

        expect(page).to have_content '登録しました'
        expect(page).to have_content 'Test Character'
      end
    end

    context '入力に不備がある場合' do
      it 'アイテム名と関連アイテムが空の場合エラーになる' do
        visit new_packing_list_path

        click_button '登録する'

        expect(page).to have_content 'アイテム名を入力、または関連アイテムを選択してください'
      end
    end
  end

  describe 'パッキングリストの編集' do
    let!(:packing_list) { create(:packing_list, user: user, item: '編集前アイテム') }

    it 'アイテム名を編集できる' do
      visit edit_packing_list_path(packing_list)

      fill_in 'アイテム名', with: '編集後アイテム'
      click_button '更新する'

      expect(page).to have_content '更新しました'
      expect(page).to have_content '編集後アイテム'
    end
  end
end
