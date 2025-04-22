require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_one_attached(:image) }
  end

  describe 'バリデーション' do
    let(:profile) { build(:profile) }

    it 'プロフィールの作成ができること' do
      expect(profile).to be_valid
    end
  end

  describe 'enum' do
    it 'activityのenumが正しく設定されること' do
      should define_enum_for(:activity).with_values(
        no_activity: 0,
        layer: 1,
        camera: 2
      )
    end
  end

  describe 'プロフィール画像' do
    it '画像の添付ができること' do
      profile = create(:profile, :with_jpeg_image)
      expect(profile.image).to be_attached
    end
  end
end