module XboxVideo
  class Clip
    attr_accessor :uri, :file_size, :uri_type, :expiration

    def initialize(block)
      @uri = block['uri']
      @file_size = block['fileSize']
      @uri_type = block['uriType']
      @expiration = block['expiration']
    end
  end
end