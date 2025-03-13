# frozen_string_literal: true

class ImportPhotos < GLCommand::Callable
  requires path: String
  allows series: Series

  def call
    target = series || Series.create

    context.path = File.realpath(context.path)

    if File.file?(path)
      return unless path.match?(/\.jpe?g$/) || path.match?(/\.png$/)

      picture = Picture.find_or_create_by(path:)
      Item.find_or_create_by(sortable: picture, series: target)
    else
      Dir.each_child(path) do |child|
        ImportPhotos.call(path: [path, child].join('/'), series: target)
      end
    end
  end
end
