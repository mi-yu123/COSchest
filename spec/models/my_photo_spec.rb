require 'rails_helper'

RSpec.describe MyPhoto, type: :model do
  let(:user) { create(:user) }
  let(:my_photo) { build(:my_photo, user: user) }

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_one_attached(:image) }
  end

  describe 'バリデーション' do
    describe 'image のバリデーション' do
      let(:my_photo) { build(:my_photo) }

      context 'imageの形式' do
        it 'imageが jpeg 形式の場合' do
          my_photo = build(:my_photo, :with_jpeg_image)
          expect(my_photo).to be_valid
        end

        it 'imageが png 形式の場合' do
          my_photo = build(:my_photo, :with_png_image)
          expect(my_photo).to be_valid
        end

        it 'imageが jpeg png ではない場合' do
          my_photo = build(:my_photo, :with_invalid_image)
          my_photo.valid?
          expect(my_photo.errors[:image]).to include('ファイルの形式はJPEGまたはPNGである必要があります。')
        end
      end

      context 'imageのサイズ' do
        before do
          allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(6.megabytes)
        end

        it 'imageのサイズが5MBを超える場合' do
          my_photo = build(:my_photo, :with_jpeg_image)
          my_photo.valid?
          expect(my_photo.errors[:image]).to include('ファイルサイズは5MB以下である必要があります。')
        end
      end
    end
  end

  describe '#resize_image' do
    let(:my_photo) { create(:my_photo, :with_jpeg_image) }

    context 'imageがある場合' do
      it 'imageをリサイズする' do
        expect(my_photo.resize_image).to be_present
      end
    end
  end

  describe '#set_posted_at' do
    let(:my_photo) { build(:my_photo, :with_jpeg_image, user: user) }

    it '作成時に posted_at を設定する' do
      my_photo.save!
      expect(my_photo.reload.posted_at).to be_within(1.second).of(Time.current)
    end
  end
end
