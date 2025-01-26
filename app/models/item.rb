# frozen_string_literal: true

class Item < ApplicationRecord
  include Consolidatable
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

  scope :without_relations, -> { where.missing(:larger_than_relations, :smaller_than_relations) }

  consolidates :relations_count
  consolidates :relations_weight

  def make_bigger_than(other)
    Items::MakeBiggerJob.perform_later(item1_id: id, item2_id: other.id)
  end

  def <=>(other)
    return 1 if larger_than?(other)
    return -1 if smaller_than?(other)

    consolidated_relations_weight <=> other.consolidated_relations_weight
  end

  def larger_than?(other)
    ItemCache.larger_than?(id, other.id)
  end

  def smaller_than?(other)
    ItemCache.smaller_than?(id, other.id)
  end

  def relations_count
    larger_than_relations.count + smaller_than_relations.count
  end

  def relations_weight
    larger_than_relations.count - smaller_than_relations.count
  end

  def to_s
    "id: #{id}, value: #{value}"
  end
end
