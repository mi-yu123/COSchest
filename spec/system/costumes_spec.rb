require 'rails_helper'

RSpec.describe "Costumes", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:costume) { create(:costume, user: user) }

  before do
    driven_by(:rack_test)
  end

  describe "衣装の登録と編集機能" do
    context 'ログインしていない場合' do
      it '衣装一覧ページにアクセスできない' do
        visit costumes_path
        expect(current_path).to eq new_user_session_path
      end

      it '衣装新規作成ページにアクセスできない' do
        visit new_costume_path
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      describe "衣装一覧表示" do
        it "自分の衣装が表示される" do
          costume
          visit costumes_path
          expect(page).to have_content(costume.character_name)
        end

        it "他のユーザーの衣装が表示されない" do
          other_costume = create(:costume, user: other_user)
          visit costumes_path
          expect(page).not_to have_content(other_costume.character_name)
        end
      end

      describe "衣装新規登録" do
        it "新規登録に成功する" do
          visit new_costume_path
          fill_in "キャラクター名", with: "Test Costume"
          select "完成", from: "状態"
          fill_in "メモ", with: "This is a test costume."
          click_button "登録する"
          expect(page).to have_content("衣装が登録されました")
          expect(page).to have_content("Test Costume")
        end
      end

      describe "衣装編集" do
        it "自分の衣装を編集できる" do
          visit edit_costume_path(costume)
          fill_in "キャラクター名", with: "Updated Costume"
          click_button "更新する"

          expect(page).to have_content("衣装が更新されました")
          expect(page).to have_content("Updated Costume")
        end
      end
    end
  end
end
