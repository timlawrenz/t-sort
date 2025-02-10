# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    series
    sortable { picture }
  end
end
