# frozen_string_literal: true

module Items
  class FindMissingTouple < GLCommand::Callable
    requires :scope
    allows item1: Item
    returns touple: ItemTouple

    def call
      context.item1 ||= least_amount_of_relations
      context.touple = ItemTouple.new(context.item1, mid_window_item(context.item1))

      context.error = touple.errors unless touple.valid?
    end

    private

    def least_amount_of_relations
      scope.order(relations_count: :asc).limit(5).sample
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

    def item_unrelated_to_item1
      id = touple.item1.id
      scope
        .where.not(id:)
        .left_joins(:smaller_than_relations, :larger_than_relations)
        .where.not(smaller_than_relations: { item1_id: id })
        .where.not(larger_than_relations: { item2_id: id })
        .group(:id)
        .limit(5)
        .sample
    end
  end
end
