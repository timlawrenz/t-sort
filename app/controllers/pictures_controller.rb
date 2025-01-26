# frozen_string_literal: true

class PicturesController < ApplicationController
  def index
    series = Series.all.sample
    picture_id = params[:picture_id]
    item1 = Picture.find(picture_id)&.item if picture_id
    @touple = series.find_missing_touple(item1: item1)
  end

  def show
    @picture = Picture.find(params[:id])
    fresh_when(@picture)

    send_file(@picture.path)
  end
end
