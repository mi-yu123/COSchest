FactoryBot.define do
  factory :packing_list do
    association :user
    item { Faker::Lorem.word }
    packed { false }

    trait :with_costume do
      item { nil }
      association :itemable, factory: :costume
    end

    trait :with_wig do
      item { nil }
      association :itemable, factory: :wig
    end

    trait :with_contact_lens do
      item { nil }
      association :itemable, factory: :contact_lens
    end
  end
end
