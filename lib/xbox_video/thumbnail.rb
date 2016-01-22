module XboxVideo
  class Thumbnail
    attr_accessor :uri, :file_size, :size

    def initialize(block)
      @uri = block['uri']
      @file_size = block['fileSize']
      @size = block['thumbnailType']
    end
  end
end