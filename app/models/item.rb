# frozen_string_literal: true

class Item < ApplicationRecord
  include IdentityCache

  belongs_to :series, touch: true
  belongs_to :sortable, polymorphic: true

  has_many :larger_than_relations, foreign_key: :item1_id,
                                   class_name: 'Relation',
                                   dependent: :destroy,
                                   inverse_of: 'item1'
  has_many :smaller_items, through: :larger_than_relations, class_name: 'Item', source: :item2
  has_many :smaller_than_relations, foreign_key: :item2_id,
                                    class_name: 'Relation',
                                    dependent: :destroy,
                                    inverse_of: 'item2'
  has_many :larger_items, through: :smaller_than_relations, class_name: 'Item', source: :item1

  before_validation :set_counts, on: :create

  scope :without_relations, -> { where.missing(:larger_than_relations, :smaller_than_relations) }

  def make_bigger_than(other)
    Items::MakeBiggerJob.perform_later(item1_id: id, item2_id: other.id)
  end

  def <=>(other)
    return 1 if larger_than?(other)
    return -1 if smaller_than?(other)

    relations_weight <=> other.relations_weight
  end

  def larger_than?(other)
    ItemCache.larger_than?(id, other.id)
  end

  def smaller_than?(other)
    ItemCache.smaller_than?(id, other.id)
  end

  def update_relations_count!
    update(relations_count: larger_than_relations.count + smaller_than_relations.count,
           relations_weight: larger_than_relations.count - smaller_than_relations.count)
  end

  def to_s
    "id: #{id}, value: #{value}"
  end

  private

  def set_counts
    self.relations_count = 0
    self.relations_weight = 0
  end
end
