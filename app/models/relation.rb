# frozen_string_literal: true

class Relation < ApplicationRecord
  include IdentityCache

  belongs_to :item1, class_name: 'Item', touch: true
  belongs_to :item2, class_name: 'Item', touch: true

  validates :item1_id, uniqueness: { scope: :item2_id }
  validate :items_are_different

  cache_index :item1_id, :item2_id, unique: true

  after_create { ItemCache.reset! }
  after_create :update_items_relations_count
  after_destroy :update_items_relations_count

  def self.any_for?(item1_id, item2_id)
    fetch_by_item1_id_and_item2_id(item1_id, item2_id).present? ||
      fetch_by_item1_id_and_item2_id(item2_id, item1_id).present?
  end

  private

  def items_are_different
    errors.add(:item1, "can't be identical to item2") if item2 == item1
  end

  def update_items_relations_count
    item1.update_relations_count!
    item2.update_relations_count!
  end
end
