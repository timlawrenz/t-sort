# frozen_string_literal: true

class SeriesController < ApplicationController
  def show
    @series = Series.fetch(params[:id])
    fresh_when(@series)

    @sticky = sticky
    result = Items::FindMissingTouple.call(item1:, scope: @series.items)
    @touple = result.touple if result.success?
  end

  def top5
    @series = Series.fetch(params[:id])
    fresh_when(@series)

    @top5 = @series.top5
  end

  def statistics
    @series = Series.fetch(params[:id])
    fresh_when(@series)

    @items_count = @series.items.count
    @without_relations_count = @series.items.without_relations.count
    @highest_relation_count = @series.items.maximum(:relations_count)
    @lowest_relation_count = @series.items.minimum(:relations_count)
  end

  private

  def sticky
    ActiveRecord::Type::Boolean.new.deserialize(params[:sticky])
  end

  def item1
    picture_id = params[:picture_id]
    return Picture.find(picture_id).item if picture_id

    nil
  end
end
