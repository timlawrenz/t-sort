# frozen_string_literal: true

module Items
  class FindMissingTouple < GLCommand::Callable
    requires :scope
    allows item1: Item
    returns touple: Array

    def call
      context.item1 ||= item1 ||
                        any_item_without_relation ||
                        least_amount_of_relations
      context.touple = [context.item1, mid_window_item(context.item1)]

      context.error = 'No two elements found.' if context.touple.size != 2
      context.error = 'Elements have a relation already.' if Relation.any_for?(context.touple.first.id, context.touple.last.id)
    end

    private

    def scope_size
      @scope_size ||= scope.count
    end

    def random_window
      @random_window ||= scope_size / 10
    end

    def default_scope
      @default_scope ||= scope.left_joins(:smaller_than_relations).limit(100)
    end

    def any_item_without_relation
      scope.where(relations_count: 0)
           .limit(random_window)
           .sample
    end

    def least_amount_of_relations
      scope.order(relations_count: :asc)
           .limit(random_window)
           .sample
    end

    def mid_window_item(item)
      sorted_items = scope.except(item).sort.reverse
      upper_border = item.larger_items.min || sorted_items.first
      lower_border = item.smaller_items.max || sorted_items.last

      upper_border_index = sorted_items.find_index(upper_border)
      lower_border_index = sorted_items.find_index(lower_border)

      index = ((upper_border_index + lower_border_index) / 2) + rand(-3..3)
      index += 1 if sorted_items[index] == item
      sorted_items[index]
    end

    def any_item_with_missing_relation
      scope.joins('LEFT OUTER JOIN "relations" LR ON LR.item1_id = items.id')
           .joins('LEFT OUTER JOIN "relations" SR ON SR.item2_id = items.id')
           .joins('LEFT OUTER JOIN "items" LR_I ON LR.item2_id = LR_I.id')
           .joins('LEFT OUTER JOIN "items" SR_I ON SR.item2_id = SR_I.id')
           .where('SR_I.id IS NULL OR LR_I.id IS NULL')
           .limit(random_window)
           .sample
    end

    def item_unrelated_to_item1
      id = touple.first&.id
      scope
        .where.not(id:)
        .left_joins(:smaller_than_relations, :larger_than_relations)
        .where.not(smaller_than_relations: { item1_id: id })
        .where.not(larger_than_relations: { item2_id: id })
        .group(:id)
        .limit(random_window)
        .sample
    end
  end
end
