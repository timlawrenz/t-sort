# frozen_string_literal: true

class SeriesController < ApplicationController
  def show
    @series = Series.fetch(params[:id])
    fresh_when(@series)

    picture_id = params[:picture_id]
    item1 = Picture.find(picture_id)&.item if picture_id
    result = Items::FindMissingTouple.call(item1: item1, scope: @series.items)
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
end
