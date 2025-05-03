require 'rails_helper'

RSpec.describe "Wigs", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:wig) { create(:wig, user: user) }

  before do
    driven_by(:rack_test)
  end

  describe "ウィッグの登録と編集機能" do
    context 'ログインしていない場合' do
      it 'ウィッグ一覧ページにアクセスできない' do
        visit wigs_path
        expect(current_path).to eq new_user_session_path
      end

      it 'ウィッグ新規作成ページにアクセスできない' do
        visit new_wig_path
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      describe "ウィッグ一覧表示" do
        it "自分のウィッグが表示される" do
          wig
          visit wigs_path
          expect(page).to have_content(wig.character_name)
        end

        it "他のユーザーのウィッグが表示されない" do
          other_wig = create(:wig, user: other_user)
          visit wigs_path
          expect(page).not_to have_content(other_wig.character_name)
        end
      end

      describe "ウィッグ新規登録" do
        it "新規登録に成功する" do
          visit new_wig_path
          fill_in "キャラクター名", with: "Test Wig"
          select "完成", from: "状態"
          fill_in "メモ", with: "This is a test wig."
          click_button "登録する"
          expect(page).to have_content("ウィッグが登録されました")
          expect(page).to have_content("Test Wig")
        end
      end

      describe "ウィッグ編集" do
        it "自分のウィッグを編集できる" do
          visit edit_wig_path(wig)
          fill_in "キャラクター名", with: "Updated Wig"
          click_button "更新する"

          expect(page).to have_content("ウィッグが更新されました")
          expect(page).to have_content("Updated Wig")
        end
      end
    end
  end
end
