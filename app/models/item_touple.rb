class ItemTouple
  include ActiveModel::Validations

  attr_accessor :item1, :item2

  validate :items_are_not_equal
  validate :items_have_no_relation

  def initialize(item1, item2)
    @item1 = item1
    @item2 = item2
  end

  private

  def items_are_not_equal
    errors.add(:item1, 'Items are equal.') if item1 == item2
  end

  def items_have_no_relation
    errors.add(:item1, 'Elements have a relation already.') if Relation.any_for?(item1.id, item2.id)
  end
end
