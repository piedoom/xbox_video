require 'rest-client'
require 'json'
require 'yaml'
require 'open-uri'

require_relative 'video'

BASE_URL = 'https://gameclipsmetadata.xboxlive.com'
GAME_LIST = YAML.load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'games.yml'))

module XboxVideo
  class Client
    def initialize(key)
      @key = key
    end

    # users can search by specifying the game title or game id
    def get_videos(game: nil, game_id: nil)

      # check if user specified a game_id
      if game_id.nil?
        # get random game if none listed
        game.nil? ? game_id = GAME_LIST[GAME_LIST.keys.sample] : game_id = GAME_LIST[game.downcase.gsub(":",' ')]
      end

      uri = "#{BASE_URL}/public/titles/#{game_id}/clips?qualifier=created&type=userGenerated"
      puts uri
      response = RestClient.get(uri, :'Authorization' => @key, :'contract_version' => 2)
      parsed = JSON.parse(response)
      videos = create_videos(parsed)
    end

    # download a clip.  Pass in a video object and a pathname.
    def download(video:,path:)
      path = "#{video.game} #{video.title} #{video.clip_id}"
      File.open("#{path}.mp4",'wb') do |save_file|
        open(video.clips.first.uri, 'rb') do |read_file|
          save_file.write(read_file.read)
        end
      end
    end

    def download_random(path: )
      videos = get_videos
      video = videos.sample
      download(video: video, path: path)
    end

    # pass in an array of video objects to be downloaded
    def download_all(videos:,path:)
      videos.each do |video|
        download(video: video, path: path)
      end
    end

    private

    def create_videos videos_hash
      videos = []
      videos_hash['gameClips'].each do |video|
        videos.push(XboxVideo::Video.new(video))
      end

      videos

    end

  end
end