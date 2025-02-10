# frozen_string_literal: true

class PicturesController < ApplicationController
  def show
    @picture = Picture.fetch(params[:id])
    fresh_when(@picture)

    send_file(@picture.path, disposition: 'inline')
  end
end
