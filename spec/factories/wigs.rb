FactoryBot.define do
  factory :wig do
    character_name { 'Test Character' }
    status { :completed }
    memo { 'Test memo' }
    user

    trait :with_jpeg_image do
      after(:build) do |wig|
        wig.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpeg')),
          filename: 'test.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :with_png_image do
      after(:build) do |wig|
        wig.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.png')),
          filename: 'test.png',
          content_type: 'image/png'
        )
      end
    end

    trait :with_invalid_image do
      after(:build) do |wig|
        wig.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.gif')),
          filename: 'test.gif',
          content_type: 'image/gif'
        )
      end
    end
  end
end

