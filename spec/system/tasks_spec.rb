require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let!(:tasks) { create_list(:task, 3, user: user) }

  before do
    driven_by(:rack_test)
    sign_in user
  end

  describe "タスク管理" do
    describe 'タスク一覧が表示される' do
      it 'タスクタイトルが表示されること' do
        visit tasks_path
        tasks.each do |task|
          expect(page).to have_content(task.title)
        end
      end
    end
  end

  describe 'タスク作成' do
    it '新しいタスクを作成できる', js: true do
      visit tasks_path
      click_on '新規タスク作成'
      fill_in 'タイトル', with: '新しいタスク'
      fill_in '説明', with: 'タスクの説明'
      fill_in '期限', with: Date.tomorrow.to_s
      click_on '作成'

      expect(page).to have_content('新しいタスク')
    end
  end

  describe 'タスク編集' do
    let!(:task) { create(:task, user: user) }

    it 'タスクを編集できる', js: true do
      visit tasks_path
      find("#task_#{task.id}").click_on '編集'

      within first('#modal') do
        fill_in 'タイトル', with: '更新されたタスク'
        click_on '更新'
      end

      expect(page).to have_content('更新されたタスク')
    end
  end
end
