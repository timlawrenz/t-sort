# frozen_string_literal: true

class SeriesController < ApplicationController
  def show
    @series = Series.find(params[:id])
    fresh_when(@series)

    picture_id = params[:picture_id]
    item1 = Picture.find(picture_id)&.item if picture_id
    result = Items::FindMissingTouple.call(item1: item1, scope: @series.items)
    redirect_to series_path(@series) if result.failure?

    @touple = result.touple
  end

  def top5
    @series = Series.find(params[:id])
    @top5 = @series.top5
  end
end
