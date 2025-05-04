require 'rails_helper'

RSpec.describe "ContactLenses", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:contact_lens) { create(:contact_lens, user: user) }

  before do
    driven_by(:rack_test)
  end

  describe "カラコンの登録と編集機能" do
    context 'ログインしていない場合' do
      it 'カラコン一覧ページにアクセスできない' do
        visit contact_lenses_path
        expect(current_path).to eq new_user_session_path
      end

      it 'カラコン新規作成ページにアクセスできない' do
        visit new_contact_lense_path
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      describe "カラコン一覧表示" do
        it "自分のカラコンが表示される" do
          contact_lens
          visit contact_lenses_path
          expect(page).to have_content(contact_lens.name)
        end

        it "他のユーザーのカラコンが表示されない" do
          other_contact_lens = create(:contact_lens, user: other_user)
          visit contact_lenses_path
          expect(page).not_to have_content(other_contact_lens.name)
        end
      end

      describe "カラコン新規登録" do
        it "新規登録に成功する" do
          visit new_contact_lense_path
          fill_in "カラコン名", with: "Test Contact Lens"
          fill_in "枚数", with: 10
          fill_in "メモ", with: "This is a test contact lens."
          click_button "登録する"
          expect(page).to have_content("カラコンが登録されました")
          expect(page).to have_content("Test Contact Lens")
        end
      end

      describe "カラコン編集" do
        let!(:contact_lens) { create(:contact_lens, user: user) }

        it "自分のカラコンを編集できる" do
          visit edit_contact_lense_path(contact_lens)
          fill_in "カラコン名", with: "Updated Contact Lens"
          click_button "更新する"

          expect(page).to have_content("カラコンが更新されました")
          expect(page).to have_content("Updated Contact Lens")
        end
      end
    end
  end
end
