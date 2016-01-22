require_relative 'thumbnail'
require_relative 'clip'

module XboxVideo
  class Video
    attr_accessor :clip_id, :published, :publish_date, :record_date, :modified_date, :caption, :type, :duration,
                  :rating, :rating_count, :views, :title, :game, :device, :likes_count, :shares_count, :comments_count,
                  :thumbnails, :clips

    def initialize(options={})
      @clip_id = options['gameClipId']
      @published = (options['state'] == 'Published')
      @publish_date = options['datePublished']
      @record_date = options['dateRecorded']
      @modified_date = options['lastModified']
      @caption = options['userCaption']
      @type = options['userCaption']
      @duration = options['durationInSeconds']
      @rating = options['rating']
      @rating_count = options['ratingCount']
      @views = options['views']
      @title = options['clipName']
      @game = options['titleName']
      @device = options['deviceType']
      @likes_count = options['likeCount']
      @shares_count = options['shareCount']
      @comments_count = options['commentCount']
      @thumbnails = generate_thumbnails options['thumbnails']
      @clips = generate_clips options['gameClipUris']
    end

    private

    def generate_thumbnails thumbnails_hash
      thumbnails = []
      thumbnails_hash.each do |thumbnail|
        thumbnails.push(Thumbnail.new(thumbnail))
      end

      thumbnails

    end

    def generate_clips clips_hash
      clips = []
      clips_hash.each do |clip|
        clips.push(Clip.new(clip))
      end

      clips

    end

  end
end