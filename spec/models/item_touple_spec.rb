# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemTouple, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      item_touple = described_class.new(item1: item1, item2: item2)

      expect(item_touple).to be_valid
    end

    it 'is not valid with equal items' do
      item = FactoryBot.create(:item)
      item_touple = described_class.new(item1: item, item2: item)

      expect(item_touple).not_to be_valid
    end

    it 'is not valid with items that have a relation' do
      item1 = FactoryBot.create(:item)
      item2 = FactoryBot.create(:item)
      create(:relation, item1: item1, item2: item2)
      item_touple = described_class.new(item1: item1, item2: item2)

      expect(item_touple).not_to be_valid
    end
  end
end
