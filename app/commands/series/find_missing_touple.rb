# frozen_string_literal: true

module Series
  class FindMissingTouple < GLCommand::Callable
    requires series: Series
    allows item1: Item
    returns :touple

    def call
      context.item1 ||= unrated_item || item_with_few_relations || item_in_need_of_a_smaller_than_relation

      item2 = any_item_in_need_of_a_relation
      item2 ||= default_scope.where(smaller_than_relations: { item1_id: nil })
                             .where.not(id: item1.id)
                             .sample
      context.touple = [item1, item2].shuffle
    end

    private

    def default_scope
      @default_scope ||= series.items.left_joins(:smaller_than_relations).limit(100)
    end

    def unrated_item
      (items.where.missing(:larger_than_relations) &
       items.where.missing(:smaller_than_relations)).sample
    end

    def item_with_few_relations
      Item.find(
        items.joins('LEFT JOIN relations R ON (R.item1_id = items.id OR R.item2_id = items.id)')
             .group(:id)
             .order(count: :asc)
             .count
             .to_a[0..10]
             .sample
             .first
      )
    end

    def item_in_need_of_a_smaller_than_relation
      default_scope.where(smaller_than_relations: { item2_id: nil }).sample
    end

    def any_item_in_need_of_a_relation
      default_scope.where(smaller_than_relations: { item1_id: nil, item2_id: nil })
                   .where.not(id: item1.id)
                   .sample
    end
  end
end
