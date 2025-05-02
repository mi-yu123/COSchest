require 'rails_helper'

RSpec.describe 'Home', type: :system do
  context 'when the user is not logged in' do
    before { visit root_path }

    it 'displays the home page links' do
      expect(page).to have_link "衣装", href: costumes_path
      expect(page).to have_link "ウィッグ", href: wigs_path
      expect(page).to have_link "カラコン", href: contact_lenses_path
      expect(page).to have_link "リスト", href: task_selection_path
      expect(page).to have_link "BLOG", href: articles_path
      expect(page).to have_link "設定", href: profile_path
    end

    it "displays footer links" do
      expect(page).to have_link "利用規約", href: terms_path
      expect(page).to have_link "お問い合わせ", href: contact_path
      expect(page).to have_link "プライバシーポリシー", href: privacy_path
    end

    %w[衣装 ウィッグ カラコン 設定].each do |link_text|
      it "redirects '#{link_text}' link to login page" do
        click_link link_text
        expect(page).to have_current_path(new_user_session_path, ignore_query: true)
      end
    end

    it "allows access to public pages like BLOG" do
      click_link "BLOG"
      expect(page).to have_current_path(articles_path, ignore_query: true)
    end

    it "allows access to public pages like リスト" do
      click_link "リスト"
      expect(page).to have_current_path(task_selection_path, ignore_query: true)
    end
  end

  context 'when the user is logged in' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit root_path
    end

    context "with expiring contact lenses" do
      let!(:expiring_lens) {
        create(:contact_lens, user: user, name: "Test Lens", expiration_date: 1.month.from_now.beginning_of_month)
      }

      it "displays expiration warning" do
        visit root_path
        expect(page).to have_content "カラコンの使用期限が近づいています"
        expect(page).to have_content "Test Lens"
        expect(page).to have_content expiring_lens.expiration_date.strftime('%Y年%m月')
      end
    end

    context "without expiring contact lenses" do
      before do
        create(:contact_lens, user: user, expiration_date: 6.months.from_now.beginning_of_month)
      end

      it "does not display expiration warning" do
        expect(page).not_to have_content "カラコンの使用期限が近づいています"
      end
    end

    it "lets logged-in user access all protected pages" do
      {
        "衣装" => costumes_path,
        "ウィッグ" => wigs_path,
        "カラコン" => contact_lenses_path,
        "リスト" => task_selection_path,
        "BLOG" => articles_path,
        "設定" => profile_path
      }.each do |link_text, path|
        click_link link_text
        expect(page).to have_current_path(path, ignore_query: true)
        visit root_path
      end
    end
  end
end
