# frozen_string_literal: true

module Items
  class MakeBigger < GLCommand::Callable
    requires :item1_id, :item2_id

    def call
      return if Relation.any_for?(item1_id, item2_id)

      relation = Relation.create(item1:, item2:)
      raise relation.errors unless relation.valid?

      item1.smaller_than_relations.find_each do |str|
        Items::MakeBiggerJob.perform_later(item1_id: str.item1_id, item2_id:)
      end
      item2.larger_than_relations.find_each do |ltr|
        Items::MakeBiggerJob.perform_later(item1_id:, item2_id: ltr.item2_id)
      end
    end

    private

    def item1
      @item1 ||= Item.find(item1_id)
    end

    def item2
      @item2 ||= Item.find(item2_id)
    end
  end
end
