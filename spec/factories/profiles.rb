FactoryBot.define do
  factory :profile do
    association :user
    handle_name { Faker::Internet.username }
    activity { Profile.activities.keys.sample }
    genre { "アニメ" }
    message { Faker::Lorem.paragraph }

    trait :with_jpeg_image do
      after(:build) do |profile|
        profile.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpeg')),
          filename: 'test.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
