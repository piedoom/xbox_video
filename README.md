# XboxVideo

The `xbox_video` gem is an API interface for Xbox Live video recordings.  Basically, it'll find videos recently uploaded
by users to Xbox live.  It's pretty entertaining.

# Attribution

This is possible because of [gabe_k](https://github.com/gabe-k) and his work on the original python script, [xbox_live_video_thing](https://github.com/gabe-k/xbox_live_video_thing/blob/master/xbox_api_client.py).
This is simply a wrapper for his work.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xbox_video'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xbox_video

## Usage

To use, require the `xbox_video` gem.  You will need authorization before using the gem.  You can find this by signing
into your [Xbox account](https://account.xbox.com).  After signing in, go to your profile page and open up developer tools.
Find XHR requests, and look for an `Authorization` header.  It should look similar to this:

```
XBL3.0 x=3234823942052384923042398423;93482093482394...
```

The entire string is fairly long, so you may want to save it into a file, or as an environment variable.  Make sure to include
everything, including the `XBL3.0 x=...`.

Once you have your code, instantiate the XboxVideo client.  The following example assumes you have your authorization code
exported to the `XBOX_KEY` environment variable.

```ruby
client = XboxVideo::Client.new(ENV['XBOX_KEY'])
```

Once your client is instantiated, you can start to find videos.  These videos are user generated, and new.  The following will
return an array of `Video` objects from a random game.

```ruby
videos = client.get_videos
```

If you would like to search videos from a specific game, you can either specify the ID or game title.  You can browse
all known games in the `lib/xbox_video/games.yml` file.  Only several are documented right now, so please feel free to add
additional games.

```ruby
# both of these return results for forza motorsport 5
videos = client.get_videos(game: 'forza motorsport 5')
videos = client.get_videos(game_id: 2067126551)
```

Each `Video` object contains several attributes - most usefully, the `clips` attribute, which holds an array of `Clip` objects.
Each `Clip` object (usually only one per video) contains a few attributes, most usefully the `uri`, that allows us to view and download the video.

Instead of parsing everything out manually, we can simply download a video with our `Client` object.

```ruby
client.download(video: videos.first, path: '/path/to/my/desired/folder/')
```

If we wanted more, we could download an array of video objects.  Take note, this may take a long time.

```ruby
client.download_all(videos: videos, path: '/path/to/my/desired/folder/')
```

If we wanted to download a random video, we could do the following.  Take note that we don't have to search for a video first.
We can call this immediately after instantiating our `Client` object.  All we need to specify is a path.

```ruby
client.download_random(path: '/path/to/my/desired/folder/')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piedoom/xbox_video.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

