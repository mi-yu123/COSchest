FactoryBot.define do
  factory :contact_lens do
    name { Faker::Commerce.product_name }
    expiration_date { 1.month.from_now.beginning_of_month }
    quantity { rand(1..10) }
    memo { Faker::Lorem.sentence }
    association :user

    trait :with_jpeg_image do
      after(:build) do |contact_lens|
        contact_lens.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpeg')),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :with_png_image do
      after(:build) do |contact_lens|
        contact_lens.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.png')),
          filename: 'test.png',
          content_type: 'image/png'
        )
      end
    end

    trait :with_invalid_image do
      after(:build) do |contact_lens|
        contact_lens.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.gif')),
          filename: 'test.gif',
          content_type: 'image/gif'
        )
      end
    end
  end
end
