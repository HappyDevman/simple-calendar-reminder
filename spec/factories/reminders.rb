# frozen_string_literal: true

FactoryBot.define do
  factory :reminder do
    datetime { Time.zone.today + 3.days }
    message { Faker::Lorem.characters(number: 30) }
  end
end
