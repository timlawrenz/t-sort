# frozen_string_literal: true

class RelationsController < ApplicationController
  def create
    Items::MakeBiggerJob.perform_later(item1_id: create_params[:item1_id],
                                       item2_id: create_params[:item2_id])

    item1 = Item.fetch(create_params[:item1_id])
    sticky = ActiveRecord::Type::Boolean.new.deserialize(create_params[:sticky])
    if sticky
      redirect_to series_path(item1.series, picture_id: item1.sortable_id, sticky:)
    else
      redirect_to series_path(item1.series)
    end
  end

  private

  def create_params
    params[:relation]
  end
end
