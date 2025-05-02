FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }

    after(:build) do |article|
      article.content = ActionText::Content.new(Faker::Lorem.paragraph(sentence_count: 3))
    end

    association :user

    trait :with_featured_image do
      after(:build) do |article|
        article.featured_image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpeg')),
          filename: 'test.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
