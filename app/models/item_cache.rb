# frozen_string_literal: true

class ItemCache
  include Singleton

  @item_cache = {}

  def self.larger_than?(item1_id, item2_id)
    @item_cache ||= {}
    @item_cache[item1_id] ||= Relation.select(:item1_id, :item2_id).where(item1_id:)

    @item_cache[item1_id].include?(item2_id)
  end

  def self.reset!
    @item_cache = {}
  end

  def self.smaller_than?(item1_id, item2_id)
    larger_than?(item2_id, item1_id)
  end
end
