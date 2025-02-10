# frozen_string_literal: true

class Picture < ApplicationRecord
  include IdentityCache
  has_one :item, as: :sortable, dependent: :destroy

  validates :path, presence: true
end
