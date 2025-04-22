require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { build(:task, user: user) }

  describe 'アソシエーション' do
    it { should belong_to(:user) }
  end

  describe 'バリデーション' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(50).with_message("は50文字以内で入力してください") }
    it { should validate_length_of(:description).is_at_most(200).with_message("は200文字以内で入力してください") }
  end

  describe 'スコープ' do
    let!(:user) { create(:user) }
    let!(:completed_task) { create(:task, user: user, completed: true) }
    let!(:incomplete_task) { create(:task, user: user, completed: false) }
  
    describe '.default_scope' do
      it 'created_atの降順で並ぶ' do
        expect(Task.all).to eq(Task.order(created_at: :desc))
      end
    end
  
    describe '.user_tasks' do
      let!(:other_user) { create(:user) }
      let!(:other_user_task) { create(:task, user: other_user) }
  
      it '指定されたuserのタスクのみを返す' do
        expect(Task.user_tasks(user)).to include(completed_task, incomplete_task)
        expect(Task.user_tasks(user)).not_to include(other_user_task)
      end
    end
  
    describe '.completed' do
      it '完了したタスクのみを返す' do
        expect(Task.completed).to include(completed_task)
        expect(Task.completed).not_to include(incomplete_task)
      end
    end
  
    describe '.incomplete' do
      it '未完了のタスクのみを返す' do
        expect(Task.incomplete).to include(incomplete_task)
        expect(Task.incomplete).not_to include(completed_task)
      end
    end
  end  
end
