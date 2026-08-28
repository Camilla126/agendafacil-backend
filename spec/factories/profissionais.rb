FactoryBot.define do
  factory :profissional do
    nome { Faker::Name.name }
    sequence(:email) { |n| "profissional#{n}@example.com" }
    senha { "segredo123" }
  end
end
