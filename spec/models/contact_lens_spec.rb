require 'rails_helper'

RSpec.describe ContactLens, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:packing_lists).dependent(:destroy) }
    it { should have_one_attached(:image) }
  end

  describe 'バリデーション' do
    describe 'image のバリデーション' do
      let(:contact_lens) { build(:contact_lens) }

      context 'imageの形式' do
        it 'imageが jpeg 形式の場合' do
          contact_lens = build(:contact_lens, :with_jpeg_image)
          expect(contact_lens).to be_valid
        end

        it 'imageが png 形式の場合' do
          contact_lens = build(:contact_lens, :with_png_image)
          expect(contact_lens).to be_valid
        end

        it 'imageが jpeg png ではない場合' do
          contact_lens = build(:contact_lens, :with_invalid_image)
          contact_lens.valid?
          expect(contact_lens.errors[:image]).to include('ファイルの形式はJPEGまたはPNGである必要があります。')
        end
      end

      context 'imageのサイズ' do
        before do
          allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(6.megabytes)
        end

        it 'imageのサイズが5MBを超える場合' do
          contact_lens = build(:contact_lens, :with_jpeg_image)
          contact_lens.valid?
          expect(contact_lens.errors[:image]).to include('ファイルサイズは5MB以下である必要があります。')
        end
      end
    end
  end

  describe 'ransackable_attributes' do
    it 'ransack によって使用可能な属性を返す' do
      expect(ContactLens.ransackable_attributes).to include('name', 'expiration_date')
    end
  end

  describe 'ransackable_associations' do
    it 'ransack によって使用可能な関連モデルを返す' do
      expect(ContactLens.ransackable_associations).to be_empty
    end
  end

  describe 'スコープ' do
    describe 'with_expiration_date' do
      let!(:contact_lens) { create(:contact_lens, expiration_date: '2026-11-01') }
      let!(:other_contact_lens) { create(:contact_lens, expiration_date: '2025-05-01') }

      context '有効な日付が渡された場合' do
        it '一致するレコードを返す' do
          expect(ContactLens.with_expiration_date('2026-11')).to include(contact_lens)
          expect(ContactLens.with_expiration_date('2026-11')).not_to include(other_contact_lens)
        end
      end

      context '無効な日付が渡された場合' do
        it '空のリストを返す' do
          expect(ContactLens.with_expiration_date('invalid-date')).to be_empty
        end
      end
    end

    describe 'expiring_soon' do
      let!(:soon_contact_lens) { create(:contact_lens, expiration_date: 1.month.from_now.beginning_of_month) }
      let!(:other_contact_lens) { create(:contact_lens, expiration_date: 3.months.from_now.beginning_of_month) }

      it '使用期限が近いレコードを返す' do
        expect(ContactLens.expiring_soon).to include(soon_contact_lens)
        expect(ContactLens.expiring_soon).not_to include(other_contact_lens)
      end
    end
  end

  describe '使用期限を月初めに設定する' do
    it 'sets expiration_date to the beginning of the month' do
      contact_lens = build(:contact_lens)
      contact_lens.expiration_date = '2026-11-15'
      contact_lens.save
      expect(contact_lens.expiration_date).to eq(Date.new(2026, 11, 1))
    end

    it '無効な日付が入力されるとエラーが出る' do
      contact_lens = build(:contact_lens)
      contact_lens.expiration_date = '2025-14-01'
      contact_lens.save
      expect(contact_lens.errors[:expiration_date]).to include("は有効な日付ではありません")
    end
  end

  describe '#resize_image' do
    let(:contact_lens) { create(:contact_lens, :with_jpeg_image) }

    context 'imageがある場合' do
      it 'imageをリサイズする' do
        expect(contact_lens.resize_image).to be_present
      end
    end

    context 'imageがない場合' do
      let(:contact_lens) { create(:contact_lens) }

      it '何も返さない' do
        expect(contact_lens.resize_image).to be_nil
      end
    end
  end
end
