require 'rails_helper'

RSpec.describe PackingList, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:itemable).optional }
  end

  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:packing_list) { build(:packing_list, user: user) }

    context 'itemableが存在しない場合' do
      it 'itemが必須であること' do
        packing_list.item = nil
        packing_list.itemable = nil
        expect(packing_list).not_to be_valid
        expect(packing_list.errors[:item]).to include("を入力してください")
      end
    end

    context 'itemableが存在する場合' do
      it 'itemが空でもバリデーションが通ること(costume)' do
        packing_list = create(:packing_list, :with_costume)
        packing_list.item = nil
        expect(packing_list).to be_valid
      end

      it 'itemが空でもバリデーションが通ること(wig)' do
        packing_list = create(:packing_list, :with_wig)
        packing_list.item = nil
        expect(packing_list).to be_valid
      end

      it 'itemが空でもバリデーションが通ること(contact_lens)' do
        packing_list = create(:packing_list, :with_contact_lens)
        packing_list.item = nil
        expect(packing_list).to be_valid
      end
    end

    context 'itemの文字数制限' do
      it 'itemが51文字以上あれば無効であること' do
        packing_list.item = 'a' * 51
        expect(packing_list).not_to be_valid
        expect(packing_list.errors[:item]).to include("は50文字以内で入力してください")
      end

      it 'itemが50文字以内であれば有効であること' do
        packing_list.item = 'a' * 50
        expect(packing_list).to be_valid
      end
    end
  end

  describe 'itemable_present?メソッド' do
    let(:user) { create(:user) }

    context 'costumeが関連付けられている場合' do
      let(:packing_list) { create(:packing_list, :with_costume) }

      it 'trueを返すこと' do
        expect(packing_list.send(:itemable_present?)).to be true
      end
    end

    context 'wigが関連付けられている場合' do
      let(:packing_list) { create(:packing_list, :with_wig) }

      it 'trueを返すこと' do
        expect(packing_list.send(:itemable_present?)).to be true
      end
    end

    context 'contact_lensが関連付けられている場合' do
      let(:packing_list) { create(:packing_list, :with_contact_lens) }

      it 'trueを返すこと' do
        expect(packing_list.send(:itemable_present?)).to be true
      end
    end
  end

  describe 'ポリモーフィック関連付け' do
    it 'costumeと関連付けられていること' do
      packing_list = create(:packing_list, :with_costume)
      expect(packing_list.itemable).to be_a(Costume)
    end

    it 'wigと関連付けられていること' do
      packing_list = create(:packing_list, :with_wig)
      expect(packing_list.itemable).to be_a(Wig)
    end

    it 'contact_lensと関連付けられていること' do
      packing_list = create(:packing_list, :with_contact_lens)
      expect(packing_list.itemable).to be_a(ContactLens)
    end
  end
end
