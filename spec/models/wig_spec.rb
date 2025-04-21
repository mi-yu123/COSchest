require 'rails_helper'

RSpec.describe Wig, type: :model do
  let(:user) { create(:user) }
  let(:wig) { build(:wig, user: user) }

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:packing_lists).dependent(:destroy) }
    it { should have_one_attached(:image) }
  end

  describe 'enum' do
    it { should define_enum_for(:status).with_values(completed: 0, incomplete: 1) }
  end

  describe 'バリデーション' do
    describe 'image のバリデーション' do
      let(:wig) { build(:wig) }

      context 'imageの形式' do
        it 'imageが jpeg 形式の場合' do
          wig = build(:wig, :with_jpeg_image)
          expect(wig).to be_valid
        end

        it 'imageが png 形式の場合' do
          wig = build(:wig, :with_png_image)
          expect(wig).to be_valid
        end

        it 'imageが jpeg png ではない場合' do
          wig = build(:wig, :with_invalid_image)
          wig.valid?
          expect(wig.errors[:image]).to include('ファイルの形式はJPEGまたはPNGである必要があります。')
        end
      end

      context 'imageのサイズ' do
        before do
          allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(6.megabytes)
        end

        it 'imageのサイズが5MBを超える場合' do
          wig = build(:wig, :with_jpeg_image)
          wig.valid?
          expect(wig.errors[:image]).to include('ファイルサイズは5MB以下である必要があります。')
        end
      end
    end
  end

  describe 'ransackable_attributes' do
    it 'ransack によって使用可能な属性を返す' do
      expect(Wig.ransackable_attributes).to include('character_name', 'status')
    end
  end

  describe 'ransackable_associations' do
    it 'ransack によって使用可能な関連モデルを返す' do
      expect(Wig.ransackable_associations).to be_empty
    end
  end

  describe '#resize_image' do
    let(:wig) { create(:wig, :with_jpeg_image) }

    context 'imageがある場合' do
      it 'imageをリサイズする' do
        expect(wig.resize_image).to be_present
      end
    end

    context 'imageがない場合' do
      let(:wig) { create(:wig) }

      it '何も返さない' do
        expect(wig.resize_image).to be_nil
      end
    end
  end
end
