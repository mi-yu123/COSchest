FactoryBot.define do
  factory :my_photo do
    title { Faker::Lorem.sentence(word_count: 3) }
    memo { Faker::Lorem.paragraph }
    user

    trait :with_jpeg_image do
      after(:build) do |my_photo|
        my_photo.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpeg')),
          filename: 'test.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :with_png_image do
      after(:build) do |my_photo|
        my_photo.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.png')),
          filename: 'test.png',
          content_type: 'image/png'
        )
      end
    end

    trait :with_invalid_image do
      after(:build) do |my_photo|
        my_photo.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.gif')),
          filename: 'test.gif',
          content_type: 'image/gif'
        )
      end
    end
  end
end
