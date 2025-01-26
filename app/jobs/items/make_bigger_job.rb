# frozen_string_literal: true

module Items
  class MakeBiggerJob < ApplicationJob
    queue_as :default
    unique :until_and_while_executing, on_conflict: :log

    def perform(item1_id:, item2_id:)
      Items::MakeBigger.call(item1_id:, item2_id:)
    end
  end
end
