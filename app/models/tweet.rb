class Tweet < ApplicationRecord
  validates :bar, :link_to_song, :link_to_lyrics, presence: true

  scope :publishable, -> { where(published_at: nil, approved: true) }
  scope :published, -> { where.not(published_at: nil) }

  def publish
    content = "\"#{self.bar}\"" + ' - ' + self.artist

    @twitter_response = twitter_client.update(content)
    record_when_tweet_was_published
    record_twitter_tweet_id

    tweet_follow_up_with_more_details
  end

  def self.last_published
    published.order(published_at: :desc).first
  end

  def self.next
    publishable.first
  end

  private

  attr_reader :twitter_response

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_API_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_API_SECRECT_KEY"]
      config.access_token        = ENV["TWITTER_API_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_API_ACCESS_TOKEN_SECRET"]
    end
  end

  def record_when_tweet_was_published
    update_attributes(published_at: Time.now)
  end

  def record_twitter_tweet_id
    twitter_tweet_id = twitter_response.id
    update_attributes(twitter_tweet_id: twitter_tweet_id)
  end

  def tweet_follow_up_with_more_details
    follow_up_content = "Lyrics: #{self.link_to_lyrics} \nSong: #{self.link_to_song}"
    twitter_client.update(follow_up_content, in_reply_to_status_id: twitter_response.id)
  end
end
