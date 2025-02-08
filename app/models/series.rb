# frozen_string_literal: true

class Series < ApplicationRecord
  include IdentityCache

  has_many :items, dependent: :destroy

  def find_missing_touple(item1: nil)
    scope = items
    result = Items::FindMissingTouple.call!(item1: item1, scope:)
    [result.touple.first, result.touple.last].shuffle
  end

  def top5
    items.includes(:consolidations).shuffle.sort.reverse.first(5)
  end
end
