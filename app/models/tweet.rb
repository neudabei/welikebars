class Tweet < ApplicationRecord
  validates :bar, presence: true

  scope :tweetable, -> { where(tweeted_at: nil, approved: true) }
  scope :published, -> { where.not(tweeted_at: nil) }

  def publish
    twitter_client.update(bar)
    record_when_tweet_was_published
  end

  def self.last_published
    published.order(tweeted_at: :desc).first
  end

  def self.next
    tweetable.first
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

  def record_when_tweet_was_published
    update_attributes(tweeted_at: Time.now)
  end
end
