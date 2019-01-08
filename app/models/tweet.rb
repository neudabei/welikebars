class Tweet < ApplicationRecord
  scope :tweetable, -> { where(tweeted_at: nil, approved: true) }

  def send
    twitter_client.update(bar)
    record_when_tweet_was_sent
  end

  private

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_API_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_API_SECRECT_KEY"]
      config.access_token        = ENV["TWITTER_API_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_API_ACCESS_TOKEN_SECRET"]
    end
  end

  def record_when_tweet_was_sent
    update_attributes(tweeted_at: Time.now)
  end
end
